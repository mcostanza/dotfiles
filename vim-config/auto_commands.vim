autocmd BufRead,BufNewFile {Gemfile,Rakefile,Capfile,*.rake,config.ru,*.god} set ft=ruby
autocmd! BufWritePost * Neomake
autocmd BufNewFile,BufRead *.ts,*.tsx setlocal filetype=typescript

" REMOVE TRAILING WHITESPACE
autocmd BufWritePre * :%s/\s\+$//e
