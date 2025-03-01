
IMAGE_NAME := "kkroesch/bookmarks"
CONTAINER_NAME := "bookmarks-server"
PORT := "8080"
BASE_IMAGE := "nginx:alpine"

install_toolkit:
    sudo dnf install -y podman
    go install github.com/google/go-containerregistry/cmd/crane@latest
    echo 'export PATH=$PATH:$HOME/go/bin'

build:
    just yam22json
    podman build -t {{IMAGE_NAME}} .

crane:
    crane append -f index.html -f bookmarks.json -t {{IMAGE_NAME}} --base {{BASE_IMAGE}}

run:
    podman run -d --name {{CONTAINER_NAME}} -p {{PORT}}:80 {{IMAGE_NAME}}

stop:
    podman stop {{CONTAINER_NAME}}
    podman rm {{CONTAINER_NAME}}

restart:
    just stop
    just run

logs:
    podman logs -f {{CONTAINER_NAME}}

clean:
    podman rmi {{IMAGE_NAME}}

yaml2json:
    yq -o=json bookmarks.yaml > bookmarks.json
