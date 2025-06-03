const API_URL = 'http://localhost/projectGrupoBikemia/src/php';

let carrinho = JSON.parse(localStorage.getItem('carrinho')) || [];

// Carregar produtos da API e montar a vitrine
async function carregarProdutos() {
  const res = await fetch(`${API_URL}/listar_produtos.php`);
  const produtos = await res.json();
  const secao = document.querySelector('.produtos');
  secao.innerHTML = '';
  produtos.forEach(prod => {
    secao.innerHTML += `
      <article class="post" data-id="${prod.id}">
        <img src="${prod.imagem}" alt="${prod.nome}" />
        <div class="post-content">
          <h2>${prod.nome}</h2>
          <p>R$ ${Number(prod.preco).toFixed(2)}</p>
          <button class="adicionar-carrinho">Adicionar ao Carrinho</button>
        </div>
      </article>
    `;
  });
  ativarBotoesCarrinho();
}

function salvarCarrinho() {
  localStorage.setItem('carrinho', JSON.stringify(carrinho));
}

function ativarBotoesCarrinho() {
  document.querySelectorAll('.adicionar-carrinho').forEach(btn => {
    btn.onclick = function() {
      const post = btn.closest('.post');
      const id = Number(post.getAttribute('data-id'));
      const nome = post.querySelector('h2').textContent;
      const preco = Number(post.querySelector('p').textContent.replace('R$', '').replace(',', '.'));
      const img = post.querySelector('img').src;
      let item = carrinho.find(i => i.id === id);
      if (item) {
        item.quantidade++;
      } else {
        carrinho.push({id, nome, preco, quantidade: 1, imagem: img});
      }
      salvarCarrinho();
      atualizarCarrinho();
    };
  });
}

function atualizarCarrinho() {
  const lista = document.getElementById('lista-carrinho');
  lista.innerHTML = '';
  let total = 0;
  carrinho.forEach(item => {
    total += item.preco * item.quantidade;
    const li = document.createElement('li');
    li.innerHTML = `
      <img src="${item.imagem}" alt="${item.nome}" style="width:40px;height:40px;vertical-align:middle;">
      ${item.nome} x${item.quantidade} - R$ ${(item.preco * item.quantidade).toFixed(2)}
      <button class="remover-item" data-id="${item.id}" style="margin-left:10px;">Remover</button>
    `;
    lista.appendChild(li);
  });
  document.getElementById('total-carrinho').textContent = `Total: R$ ${total.toFixed(2)}`;
  document.getElementById('finalizar-compra').disabled = carrinho.length === 0;

  // Ativa botões de remover
  document.querySelectorAll('.remover-item').forEach(btn => {
    btn.onclick = function() {
      const id = Number(btn.getAttribute('data-id'));
      carrinho = carrinho.filter(item => item.id !== id);
      salvarCarrinho();
      atualizarCarrinho();
    };
  });
}

// Limpar carrinho
document.getElementById('limpar-carrinho').onclick = () => {
  carrinho = [];
  salvarCarrinho();
  atualizarCarrinho();
};

// Exigir login ao finalizar compra e enviar para o backend
document.getElementById('finalizar-compra').onclick = async function() {
  if (!usuarioLogado()) {
    alert('Você precisa estar logado para finalizar a compra!');
    return;
  }
  if (carrinho.length === 0) return;

  try {
    const token = localStorage.getItem('token'); // O token salvo no login
    const total = carrinho.reduce((s, i) => s + i.preco * i.quantidade, 0);

    const res = await fetch(`${API_URL}/finalizar_pedido.php`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token
      },
      body: JSON.stringify({ itens: carrinho, total })
    });

    const json = await res.json();

    if (json.success) {
      abrirModalCompraSucesso();
      carrinho = [];
      salvarCarrinho();
      atualizarCarrinho();
    } else {
      alert(json.error || 'Erro ao finalizar pedido!');
    }
  } catch (e) {
    alert('Erro de conexão ao finalizar pedido!');
  }
};

// Função para checar login (exemplo simples)
function usuarioLogado() {
  // Troque por sua lógica real de autenticação
  // Exemplo: return !!localStorage.getItem('token');
  return !!localStorage.getItem('usuarioLogado');
}

// Função para abrir o modal de sucesso da compra
function abrirModalCompraSucesso() {
  const modal = document.getElementById('compraSucessoModal');
  if (modal) {
    modal.classList.add('active');
    modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');
  }
}

// Função para fechar modais
function fecharModal(id) {
  const modal = document.getElementById(id);
  if (modal) {
    modal.classList.remove('active');
    modal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('modal-open');
  }
}

// Fecha modal ao clicar no X ou fora do conteúdo
document.querySelectorAll('.modal').forEach(modal => {
  modal.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal') || e.target.classList.contains('close')) {
      modal.classList.remove('active');
      modal.setAttribute('aria-hidden', 'true');
      document.body.classList.remove('modal-open');
    }
  });
});

// Fecha modal com ESC
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') {
    document.querySelectorAll('.modal.active').forEach(modal => {
      modal.classList.remove('active');
      modal.setAttribute('aria-hidden', 'true');
      document.body.classList.remove('modal-open');
    });
  }
});

// Iniciar a loja ao carregar a página
document.addEventListener('DOMContentLoaded', () => {
  carregarProdutos();
  atualizarCarrinho();
});