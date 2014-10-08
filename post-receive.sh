#!/usr/bin/env bash


while read oldrev newrev ref
do

  # For every branch or tag that was pushed, create a Resque job in redis.
  PWD=`pwd`

# AÃ±adido peter para auto deploy de los repos
if [ $(git rev-parse --is-bare-repository) = true ]
then
    REPOSITORY_BASENAME=$(basename "$PWD")
    REPOSITORY_BASENAME=${REPOSITORY_BASENAME%.git}
else
    REPOSITORY_BASENAME=$(basename $(readlink -nf "$PWD"/..))
fi
#grupo de la aplicacion
REPOSITORY_BASENAME="$(basename $(dirname "$PWD"))/$REPOSITORY_BASENAME"

#directorio donde se guardan todos las copias
WEBSERVER_DIR="/path/to/webserver"
#directorio especifico para esta copia
DEPLOY_COPY_DIR="$WEBSERVER_DIR/$REPOSITORY_BASENAME"
#branch que se usara en deploy
DEPLOY_COPY_BRANCH="master"

#acciones

if [ "$ref" == "refs/heads/$DEPLOY_COPY_BRANCH" ]; then
#       echo "branch master"
    if [ -d "$DEPLOY_COPY_DIR" ]; then
#       echo "existe"
            cd $DEPLOY_COPY_DIR
            GIT_WORK_TREE=$DEPLOY_COPY_DIR
            GIT_DIR="$DEPLOY_COPY_DIR/.git"
            git reset --hard
            git pull origin $DEPLOY_COPY_BRANCH
    else
#       echo "no existe"
#       mkdir -p $DEPLOY_COPY_DIR
        git clone -b $DEPLOY_COPY_BRANCH $PWD $DEPLOY_COPY_DIR
    fi
fi

#echo "final"

done