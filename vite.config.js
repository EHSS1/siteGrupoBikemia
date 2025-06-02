import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    rollupOptions: {
      input: {
        main: './index.html',
        bikemia: './bikemia.html',
        blog: './blog.html',
        contato: './contato.html',
        eventos: './eventos.html',
        galeria: './galeria.html',
        parcerias: './parcerias.html',
        trilhas: './trilhas.html'
      }
    }
  }
});


