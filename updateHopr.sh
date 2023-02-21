DIR="$HOME/.hoprd-db-monte-rosa"
if [ -d "$DIR" ]; then
    echo "Found DB in new location..."
    echo "Starting Admin UI..."
else 
    echo "Moving DB to new location..."
    cp -r $HOME/.hoprd-db-valencia $HOME/.hoprd-db-monte-rosa
    cp -r $HOME/.hoprd-db-valencia/.hopr-id-valencia $HOME/.hoprd-db-monte-rosa/.hopr-id-monte-rosa
    cp -r $HOME/.hoprd-db-bogota $HOME/.hoprd-db-monte-rosa
    cp -r $HOME/.hoprd-db-bogota/.hopr-id-bogota $HOME/.hoprd-db-monte-rosa/.hopr-id-monte-rosa
    echo "Moved DB!"
fi    
ID=`docker container ls | grep gcr.io/hoprassociation/hoprd | grep -o "^\w*\b"`
echo "$ID"
docker stop $ID 
echo "Starting Admin UI..."
docker container stop hopr_admin
docker rm hopr_admin
docker run -d --name hopr_admin -p 3000:3000 gcr.io/hoprassociation/hopr-admin
echo "Started Admin UI..."
echo "Starting Node..."
docker run --pull always --restart on-failure -m 2g --log-driver json-file --log-opt max-size=100M --log-opt max-file=5 -ti -v $HOME/.hoprd-db-bogota:/app/hoprd-db -p 9091:9091 -p 3001:3001 -e DEBUG="hopr*" gcr.io/hoprassociation/hoprd:1.92.9 --environment monte_rosa --init --api --identity /app/hoprd-db/.hopr-id-bogota --data /app/hoprd-db --password 'open-sesame-iTwnsPNg0hpagP+o6T0KOwiH9RQ0' --apiHost "0.0.0.0" --apiToken 'Fk80!5L-faaO1R47m!kThkL' --healthCheck --healthCheckHost "0.0.0.0"
