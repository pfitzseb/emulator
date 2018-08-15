 #!/bin/sh
hugo && rsync -avz --delete redir/ pfitzseb@pool13.physik.hu-berlin.de:~/public_html
exit 0
