#!/bin/bash

# Initialiser le score
score=0
 
###Test de la question 1
# Lire le fichier et chercher le mot "running"
var_q1=$(grep -i "running" result_question1.txt)

# Vérifier si var_q1 n'est pas vide
if [ -n "$var_q1" ]; then
  score=$((score + 3))
fi


###Test de la question 2
# Lire le fichier et chercher le mot "running"
var_q2=$(grep -i "running" result_question2.txt)

# Vérifier si var_q2 n'est pas vide
if [ -n "$var_q2" ]; then
  score=$((score + 3))
fi


###Test de la Question 3
# Lire le fichier et chercher les mots clés indiquant différents types d'objets et namespaces
var_q3_objects=$(grep -E "pod|service|deployment|replicaset" result_question3.txt)
var_q3_namespaces=$(grep -i "NAMESPACE" result_question3.txt)

# Vérifier si les deux variables ne sont pas vides
if [ -n "$var_q3_objects" ] && [ -n "$var_q3_namespaces" ]; then
  score=$((score + 3))
fi

### Test de la question 4
# Vérifier la création du Pod
var_pods=$(grep -i "my-static-pod" result_question4_pods.txt)
if [ -n "$var_pods" ]; then
  score=$((score + 3))
fi

# Vérifier la création du Service
var_service=$(grep -i "static-pod-service" result_question4_service.txt)
if [ -n "$var_service" ]; then
  score=$((score + 3))
fi

# Vérifier la présence des Endpoints
var_endpoints=$(grep -i "my-static-pod" result_question4_endpoints.txt)
if [ -n "$var_endpoints" ]; then
  score=$((score + 2))
fi

# Vérifier l'accessibilité du Service
var_access=$(grep -i "Welcome to nginx" result_question4_access.txt)
if [ -n "$var_access" ]; then
  score=$((score + 2))
fi


### Test de la question 5
# Vérifier la création du déploiement
var_deployment=$(grep -i "apache" result_question5_deployment.txt)
if [ -n "$var_deployment" ]; then
  score=$((score + 1))
fi

# Vérifier que le déploiement a 3 réplicas
var_replicas=$(grep -i "3/3" result_question5_deployment.txt)
if [ -n "$var_replicas" ]; then
  score=$((score + 2))
fi

# Vérifier que 3 pods sont créés
var_pods=$(grep -c "Running" result_question5_pods.txt)
if [ "$var_pods" -eq 3 ]; then
  score=$((score + 2))
fi

### Test question 6
# Vérifier la création du déploiement
var_deployment=$(grep -i "nginx-deployment" result_question6_deployment.txt)
if [ -n "$var_deployment" ]; then
  score=$((score + 1))
fi

# Vérifier la création du service
var_service=$(grep -i "nginx-service" result_question6_service.txt)
if [ -n "$var_service" ]; then
  score=$((score + 2))
fi

# Vérifier la création de l'ingress
var_ingress=$(grep -i "nginx-ingress-resource" result_question6_ingress.txt)
if [ -n "$var_ingress" ]; then
  score=$((score + 2))
fi

# Vérifier le chemin de l'ingress
var_path=$(grep -i "/shop" result_question6_ingress.txt)
if [ -n "$var_path" ]; then
  score=$((score + 1))
fi


## Test Question 7

# Vérifier la création du namespace
var_namespace=$(grep -i "ns-dmset" result_question7_namespace.txt)
if [ -n "$var_namespace" ]; then
  score=$((score + 2))
fi

# Vérifier la création du DaemonSet
var_daemonset=$(grep -i "ds-important" result_question7_daemonset.txt)
if [ -n "$var_daemonset" ]; then
  score=$((score + 5))
fi

# Vérifier que le DaemonSet a les bons labels
var_labels=$(grep -i "18426a0b-5f59-4e10-923f-c0e078e82462" result_question7_daemonset.txt)
if [ -n "$var_labels" ]; then
  score=$((score + 3))
fi

# Vérifier que les Pods du DaemonSet sont en cours d'exécution sur tous les nœuds
# Compter les Pods en cours d'exécution
var_pods=$(grep -c "Running" result_question7_pods.txt)
# Compter le nombre de nœuds
var_nodes=$(kubectl get nodes | grep -c "")
if [ "$var_pods" -eq "$var_nodes" ]; then
  score=$((score + 4))
fi

### Test question 8
# Vérifier la création du namespace
var_namespace=$(grep -i "ns-security" result_question8_namespace.txt)
if [ -n "$var_namespace" ]; then
  score=$((score + 1))
fi

# Vérifier la création du ServiceAccount
var_serviceaccount=$(grep -i "processor" result_question8_serviceaccount.txt)
if [ -n "$var_serviceaccount" ]; then
  score=$((score + 2))
fi

# Vérifier la création du Role
var_role=$(grep -i "processor" result_question8_role.txt)
if [ -n "$var_role" ]; then
  score=$((score + 1))
fi

# Vérifier la création du RoleBinding
var_rolebinding=$(grep -i "processor" result_question8_rolebinding.txt)
if [ -n "$var_rolebinding" ]; then
  score=$((score + 2))
fi

### Test question 9
# Lire le contenu du fichier

command=$(cat result_question9.txt)

# Vérifier que la commande est correcte
if [ "$command" == "kubectl get events --all-namespaces --sort-by=.metadata.creationTimestamp" ]; then
  score=$((score + 2))
fi

###Test Question 10 
# Vérifier la création du déploiement
var_deployment=$(kubectl get deployment cache-deployment -o jsonpath='{.spec.replicas}')
if [ "$var_deployment" == "2" ]; then
  score=$((score + 2))
fi

# Vérifier la stratégie de mise à jour
var_strategy=$(kubectl get deployment cache-deployment -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}')
if [ "$var_strategy" == "30%" ]; then
  score=$((score + 1))
fi

var_strategy=$(kubectl get deployment cache-deployment -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}')
if [ "$var_strategy" == "45%" ]; then
  score=$((score + 1))
fi

# Vérifier que tous les Pods sont prêts
var_pods=$(kubectl get pods -l app=cache -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}')
if [[ "$var_pods" == "True True" ]]; then
  score=$((score + 2))
fi

# Vérifier la mise à jour de l'image
var_image=$(kubectl get deployment cache-deployment -o jsonpath='{.spec.template.spec.containers[0].image}')
if [ "$var_image" == "redis:7.2.1" ]; then
  score=$((score + 4))
fi

# Vérifier le nombre total de révisions
var_revision=$(cat result_question10_total-revision.txt)
if [ -n "$var_revision" ]; then
  score=$((score + 3))
fi

#### Test question11
# Vérifier la création du Pod
var_pod=$(grep -i "alpine-pod" result_question11_pod.txt)
if [ -n "$var_pod" ]; then
  score=$((score + 2))
fi

# Vérifier que le Pod utilise la bonne image
var_image=$(kubectl get pod alpine-pod -o jsonpath='{.spec.containers[0].image}')
if [ "$var_image" == "httpd:2.4.41-alpine" ]; then
  score=$((score + 2))
fi

# Vérifier la création du Service
var_service=$(grep -i "alpine-service" result_question11_service.txt)
if [ -n "$var_service" ]; then
  score=$((score + 2))
fi

# Vérifier que le Service expose le bon port
var_port=$(kubectl get svc alpine-service -o jsonpath='{.spec.ports[0].port}')
if [ "$var_port" == "80" ]; then
  score=$((score + 2))
fi



###Test de la question 12

# Vérifier la création du Pod frontend
var_q12_check_frontend=$(grep -i "frontend" result_question12_frontend.txt)
if [ -n "$var_q12_check_frontend" ]; then
  score=$((score + 1))
fi

# Vérifier que le Pod frontend utilise la bonne image
var_q12_check_frontend_image=$(kubectl get pod frontend -o jsonpath='{.spec.containers[0].image}')
if [ "$var_q12_check_frontend_image" == "nginx:latest" ]; then
  score=$((score + 1))
fi

# Vérifier la création du Pod backend
var_q12_check_backend=$(grep -i "backend" result_question12_backend.txt)
if [ -n "$var_q12_check_backend" ]; then
  score=$((score + 1))
fi

# Vérifier que le Pod backend utilise la bonne image
var_q12_check_backend_image=$(kubectl get pod backend -o jsonpath='{.spec.containers[0].image}')
if [ "$var_q12_check_backend_image" == "nginx:latest" ]; then
  score=$((score + 1))
fi

# Vérifier la création du Pod db
var_q12_check_db=$(grep -i "db" result_question12_db.txt)
if [ -n "$var_q12_check_db" ]; then
  score=$((score + 1))
fi

# Vérifier que le Pod db utilise la bonne image
var_q12_check_db_image=$(kubectl get pod db -o jsonpath='{.spec.containers[0].image}')
if [ "$var_q12_check_db_image" == "nginx:latest" ]; then
  score=$((score + 1))
fi

# Vérifier la création de la Network Policy
var_q12_check_networkpolicy=$(grep -i "allow-frontend-to-backend" result_question12_networkpolicy.txt)
if [ -n "$var_q12_check_networkpolicy" ]; then
  score=$((score + 1))
fi

# Je recherche ou va le traffic avec une commande jsonpath et je le met dans une variable
var_q12_chechink_backend=$(kubectl get networkpolicy -o jsonpath=‘{.items[*].spec.ingress[*].from[*].podSelector.matchLabels.app}’)

# Vérifier si le traffic va vers le backend
if [ $var_q12_chechink_backend="backend" ]; then
  score=$((score + 2))
fi

# Je recherche d'ou vient le traffic avec une commande jsonpath et je le met dans une variable
var_q12_chechink_frontend=$(kubectl get networkpolicy -o jsonpath=‘{.items[*].spec.podSelector.matchLabels.app}’)

# Vérifier si le traffic vient du frontend
if [ $var_q12_chechink_frontend="front" ]; then
  score=$((score + 1))
fi

# Je recherche le port sur lequel le traffic est autorise vers le backend
# avec une commande jsonpath et je le met dans une variable
var_q12_chechink_port=$(kubectl get networkpolicy -o jsonpath=‘{.items[*].spec.ingress[*].ports[*].port}’)

# Vérifier si le traffic est autoris sur le port 80
if [ $var_q12_chechink_port="80" ]; then
  score=$((score + 2))
fi


##TEST QUESTION 13

# Vérifier la création du Pod busybox-pod1
var_q13_check_busybox_pod1=$(grep -i "busybox-pod1" result_question13_busybox_pod1.txt)
if [ -n "$var_q13_check_busybox_pod1" ]; then
  score=$((score + 1))
fi

# Vérifier que le Pod busybox-pod1 utilise un volume EmptyDir
var_q13_check_busybox_pod1_volume=$(kubectl get pod busybox-pod1 -o jsonpath='{.spec.volumes[?(@.emptyDir)]}')
if [ -n "$var_q13_check_busybox_pod1_volume" ]; then
  score=$((score + 1))
fi

# Vérifier la création du Pod busybox-pod2
var_q13_check_busybox_pod2=$(grep -i "busybox-pod2" result_question13_busybox_pod2.txt)
if [ -n "$var_q13_check_busybox_pod2" ]; then
  score=$((score + 2))
fi

# Vérifier que le Pod busybox-pod2 utilise un volume HostPath
var_q13_check_busybox_pod2_volume=$(kubectl get pod busybox-pod2 -o jsonpath='{.spec.volumes[?(@.hostPath)]}')
if [ -n "$var_q13_check_busybox_pod2_volume" ]; then
  score=$((score + 2))
fi

# TEST QUESTION 14
# Vérifier la création du namespace ns-pv-pvc
var_q14_check_namespace=$(grep -i "ns-pv-pvc" result_question14_namespace.txt)
if [ -n "$var_q14_check_namespace" ]; then
  score=$((score + 1))
fi

# Vérifier la création du PV my-pv
var_q14_check_pv=$(grep -i "my-pv" result_question14_pv.txt)
if [ -n "$var_q14_check_pv" ]; then
  score=$((score + 1))
fi

# Vérifier la création du PVC my-pvc
var_q14_check_pvc=$(grep -i "my-pvc" result_question14_pvc.txt)
if [ -n "$var_q14_check_pvc" ]; then
  score=$((score + 2))
fi

# Vérifier que le PVC est lié au PV
var_q14_check_pvc_bound=$(kubectl get pvc my-pvc -n ns-pv-pvc -o jsonpath='{.status.phase}')
if [ "$var_q14_check_pvc_bound" == "Bound" ]; then
  score=$((score + 1))
fi

# Vérifier la création du Deployment pv-deployment
var_q14_check_deployment=$(grep -i "pv-deployment" result_question14_deployment.txt)
if [ -n "$var_q14_check_deployment" ]; then
  score=$((score + 1))
fi

# Vérifier que le volume est monté dans le Deployment
var_q14_check_volume_mount=$(kubectl get deployment pv-deployment -n ns-pv-pvc -o jsonpath='{.spec.template.spec.containers[0].volumeMounts[0].mountPath}')
if [ "$var_q14_check_volume_mount" == "/tmp/deployment-data" ]; then
  score=$((score + 2))
fi

# Test Question 15
# Vérifier la création du Pod multi-container-playground
var_q15_check_pod=$(grep -i "multi-container-playground" result_question15_pod.txt)
if [ -n "$var_q15_check_pod" ]; then
  score=$((score + 1))
fi

# Vérifier la configuration du conteneur c1
var_q15_check_c1_image=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c1")].image}')
if [ "$var_q15_check_c1_image" == "nginx:1.17.6-alpine" ]; then
  score=$((score + 1))
fi

var_q15_check_c1_env=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c1")].env[?(@.name=="MY_NODE_NAME")].valueFrom.fieldRef.fieldPath}')
if [ "$var_q15_check_c1_env" == "spec.nodeName" ]; then
  score=$((score + 1))
fi

# Vérifier la configuration du conteneur c2
var_q15_check_c2_image=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c2")].image}')
if [ "$var_q15_check_c2_image" == "busybox:1.31.1" ]; then
  score=$((score + 1))
fi

# Vérifier la configuration du conteneur c3
var_q15_check_c3_image=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c3")].image}')
if [ "$var_q15_check_c3_image" == "busybox:1.31.1" ]; then
  score=$((score + 1))
fi

var_q15_check_volume_mount_c1=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c1")].volumeMounts[0].mountPath}')
var_q15_check_volume_mount_c2=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c2")].volumeMounts[0].mountPath}')
var_q15_check_volume_mount_c3=$(kubectl get pod multi-container-playground -o jsonpath='{.spec.containers[?(@.name=="c3")].volumeMounts[0].mountPath}')
if [ "$var_q15_check_volume_mount_c1" == "/your/vol/path" ] && [ "$var_q15_check_volume_mount_c2" == "/your/vol/path" ] && [ "$var_q15_check_volume_mount_c3" == "/your/vol/path" ]; then
  score=$((score + 2))
fi

var_q15_check_c3_logs=$(grep -i -Ec "$date" result_question15_c3_logs.txt)
if [ "$var_q15_check_c3_logs" -ge 2 ]; then
  score=$((score + 2))
fi



###########################################################
#FIN Afficher le score final (DOIT ETRE A LA FIN DU FICHIER)
###########################################################

if [ "$score" -lt 66 ]; then
  echo "##################################################################################"
  echo " Domage :( Votre score est de : $score"%" !!  le score minimum est de 66% !! :( "
  echo "##################################################################################"

elif [ "$score" -ge 66 ]; then
  echo "####################################################################################"
  echo "Felicitation :) Votre score est de : $score"%" !! le score minimum est de 66% !!"
  echo "URGENT: Pour la suite, faites des labs de killakoda.com sur le troubleshooting,"
  echo "ETCD backup, ETCD restore et cluster upgrade a fin de reussir la CKA "  
  echo "####################################################################################"
fi
