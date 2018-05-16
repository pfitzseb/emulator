 #!/bin/sh
hugo && rsync -avz --delete public/ pfitzseb@pool13.physik.hu-berlin.de:~/public_html
exit 0
