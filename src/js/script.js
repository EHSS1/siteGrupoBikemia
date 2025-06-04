const API_URL = 'http://localhost/siteGrupoBikemia/src/php';

document.addEventListener('DOMContentLoaded', () => {
  initModais();
  initForms();
  verificarSessao(); // Verifica se há sessão ativa ao carregar a página
});

function initModais() {
  document.querySelectorAll('[data-modal]').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const id = btn.getAttribute('data-modal');
      abrirModal(id);
    });
  });

  document.querySelectorAll('.modal .close').forEach(btn => {
    btn.addEventListener('click', () => fecharModal(btn.closest('.modal').id));
  });

  document.querySelectorAll('.modal').forEach(modal => {
    modal.addEventListener('click', (e) => {
      if (e.target === modal) fecharModal(modal.id);
    });
  });
}

function abrirModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    document.body.classList.add('modal-open');
    modal.classList.add('active');
    // Limpa mensagem de login ao abrir normalmente
    if (id === 'loginModal') {
      const loginMsg = document.getElementById('loginMessage');
      if (loginMsg) {
        loginMsg.textContent = "";
        loginMsg.style.display = "none";
        loginMsg.className = "message";
      }
    }
  }
}

function fecharModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    document.body.classList.remove('modal-open');
    modal.classList.remove('active');
    const form = modal.querySelector('form');
    if (form) form.reset();
  }
}

function initForms() {
  const cadastro = document.getElementById('cadastroForm');
  const login = document.getElementById('loginForm');

  if (cadastro) {
    cadastro.addEventListener('submit', async (e) => {
      e.preventDefault();

      const dados = new FormData(cadastro);

      try {
        const res = await fetch(`${API_URL}/cadastro.php`, {
          method: 'POST',
          body: dados
        });

        const text = await res.text();
        console.log("Resposta bruta:", text);
      
        const json = JSON.parse(text);

        if (json.success) {
          fecharModal('cadastroModal');
          abrirModal('loginModal');
          // Mostra mensagem de sucesso na modal de login
          const loginMsg = document.getElementById('loginMessage');
          if (loginMsg) {
            loginMsg.textContent = "Cadastro efetuado com sucesso! Faça o login para continuar.";
            loginMsg.style.display = "block";
            loginMsg.className = "message success-message";
          }
        }

      } catch (err) {
        console.error("Erro ao interpretar JSON:", err);
        alert("Erro inesperado no cadastro");
      }
    });
  }

  if (login) {
    login.addEventListener('submit', async (e) => {
      e.preventDefault();

      const dados = {
        usuario: document.getElementById('loginUsuario').value.trim(),
        senha: document.getElementById('loginSenha').value
      };

      try {
        const res = await fetch(`${API_URL}/login.php`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(dados)
        });

        const json = await res.json();

        if (json.success) {
  // Armazena o token e dados do usuário no localStorage
  localStorage.setItem('token', json.token);
  localStorage.setItem('usuarioLogado', JSON.stringify(json.usuario));

  fecharModal('loginModal');
  atualizarUIUsuario(json.usuario);
  abrirModal('bemVindoModal');
} else {
  // Mostra mensagem de erro padrão na modal de login
  const loginMsg = document.getElementById('loginMessage');
  if (loginMsg) {
    loginMsg.textContent = "Usuário ou senha inválidos.";
    loginMsg.style.display = "block";
    loginMsg.className = "message error-message";
  }
}
      } catch (err) {
        console.error("Erro no login:", err);
        const loginMsg = document.getElementById('loginMessage');
        if (loginMsg) {
          loginMsg.textContent = "Erro inesperado ao fazer login.";
          loginMsg.style.display = "block";
          loginMsg.className = "message error-message";
        }
      }
    });
  }
}

function atualizarUIUsuario(usuario = null) {
  const user = usuario || JSON.parse(localStorage.getItem('usuarioLogado'));
  const nav = document.querySelector('#menu-principal');
  if (!nav) return;

  // Remove botões de login/cadastro se existirem
  nav.querySelectorAll('[data-modal="loginModal"], [data-modal="cadastroModal"]').forEach(btn => {
    if (btn && btn.parentElement) btn.parentElement.remove();
  });

  // Remove saudação antiga se existir
  nav.querySelectorAll('.usuario-logado').forEach(el => el.parentElement.remove());

  // Se não houver usuário, mostra os botões padrão
  if (!user) {
    const loginLi = document.createElement('li');
    loginLi.innerHTML = '<a href="#" data-modal="loginModal" class="botao">Entrar</a>';
    nav.appendChild(loginLi);

    const cadastroLi = document.createElement('li');
    cadastroLi.innerHTML = '<a href="#" data-modal="cadastroModal" class="botao destaque">Cadastrar</a>';
    nav.appendChild(cadastroLi);

    // Re-inicializa os eventos dos modais para os novos botões
    initModais();
    return;
  }

  // Cria a saudação e botão de logout para usuário logado
  const nomeExibicao = user?.apelido && user.apelido.trim() !== "" ? user.apelido : user.nome;

  const li = document.createElement('li');
  li.innerHTML = `
    <span class="usuario-logado">Olá, <strong>${nomeExibicao}</strong>!</span>
    <a href="#" class="botao destaque" id="logoutBtn">Sair</a>
  `;
  nav.appendChild(li);

  // Evento de logout
  document.getElementById('logoutBtn').addEventListener('click', async (e) => {
    e.preventDefault();
    await fazerLogout();
  });
}

async function verificarSessao() {
  const token = localStorage.getItem('token');
  if (!token) return;

  try {
    const res = await fetch(`${API_URL}/verificar_sessao.php`, {
      method: 'GET',
      headers: {
        'Authorization': token
      }
    });

    const json = await res.json();

    if (json.success) {
      atualizarUIUsuario(json.usuario);
    } else {
      localStorage.removeItem('token');
      localStorage.removeItem('usuarioLogado');
      atualizarUIUsuario(); // Atualiza a UI para estado não logado
    }
  } catch (err) {
    console.error("Erro ao verificar sessão:", err);
    localStorage.removeItem('token');
    localStorage.removeItem('usuarioLogado');
  }
}

async function fazerLogout() {
  const token = localStorage.getItem('token');
  if (!token) {
    // Não tente fazer logout se não houver token
    localStorage.removeItem('usuarioLogado');
    location.reload();
    return;
  }
  
  try {
    await fetch(`${API_URL}/logout.php`, {
      method: 'POST',
      headers: { 'Authorization': token }
    });
  } catch (err) {
    console.error("Erro ao fazer logout:", err);
  } finally {
    localStorage.removeItem('token');
    localStorage.removeItem('usuarioLogado');
    location.reload();
  }
}

document.addEventListener('DOMContentLoaded', () => {
  // ...existing code...

  // Formulário de contato do rodapé
  const contatoForm = document.getElementById('contatoFooterForm');
  if (contatoForm) {
    contatoForm.addEventListener('submit', async function(e) {
      e.preventDefault();
      const msgDiv = document.getElementById('contatoFooterMsg');
      msgDiv.textContent = "Enviando...";

      const formData = new FormData(contatoForm);

      try {
        const res = await fetch('src/php/contato.php', {
          method: 'POST',
          body: formData
        });
        const json = await res.json();
        if (json.success) {
          msgDiv.textContent = "Mensagem enviada! Obrigado pelo contato.";
          contatoForm.reset();
        } else {
          msgDiv.textContent = json.error || "Erro ao enviar mensagem.";
        }
      } catch (err) {
        msgDiv.textContent = "Erro ao enviar mensagem.";
      }
    });
  }

  // Atualiza o ano no rodapé
  const ano = document.getElementById('currentYear');
  if (ano) ano.textContent = new Date().getFullYear();
});