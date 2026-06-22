-- vim-be-good: minijuegos DENTRO de nvim para practicar movimiento y edición.
-- Arranca con :VimBeGood y elige un juego (hjkl, words, ci{, etc.).
-- Sin dependencias ni setup: solo se instala y se ejecuta el comando.
return {
  "ThePrimeagen/vim-be-good",
  cmd = "VimBeGood", -- se carga solo al ejecutar :VimBeGood (no pesa al arrancar)
}
