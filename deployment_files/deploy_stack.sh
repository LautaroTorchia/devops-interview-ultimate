echo "Applying all Database changes"

cd db/
kubectl apply -f pvc.yml
kubectl apply -f secret.yml
kubectl apply -f deployment.yml 
kubectl apply -f service.yml

echo "Applying all Backend changes"

cd ../backend/
kubectl apply -f secret.yml
kubectl apply -f deployment.yml 
kubectl apply -f service.yml

echo "Applying all Frontend changes"

cd ../frontend/
kubectl apply -f deployment.yml 
kubectl apply -f service.yml

echo "Creating ingress"

cd ../ingress
kubectl apply -f ingress.yml