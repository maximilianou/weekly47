include .env
#user=..
#servers=..
## Makefile variables
# servers-if-not-set-then-default?=localhost ## if servers not set, then set with value localhost
servers-exec-cmd!=hostname  ## execute command and set stdout to variable server
servers-exec-usr-id!=id  ## execute command and set stdout to variable server

.PHONY: view-hostname
step00 view-hostname:
	@echo $(servers-exec-cmd)
	@echo '$(servers-exec-usr-id)'


step46_1301 denochat_install:
	curl -fsSL https://deno.land/x/install/install.sh | sh	
	deno --version

step46_1302 denochat_create:
	mkdir -p denochat/api 

step46_1303 denochat_ui:
	deno install -A -f --no-check -n fresh https://raw.githubusercontent.com/lucacasonato/fresh/main/cli.ts
	cd denochat && fresh init ui

step46_1304 denochat_deployctl_install:
	deno install --allow-read --allow-write --allow-env --allow-net --allow-run --no-check -r -f https://deno.land/x/deploy/deployctl.ts

step46_1305 denochat_deployctl_run:
	cd denochat/ui && deployctl run --no-check --watch main.ts

step46_1300 deno_clean:
	rm -rf denochat

#####################################################
## Functional Programming Typescript / Javascript
#step46_1000 node_typescript_init:
#	mkdir -p programming/fp01 && cd programming/fp01 && npm -y init 
#	cd programming/fp01 && npm i -D typescript ts-node
#	cd programming/fp01 && ./node_modules/.bin/tsc --init
#
#step46_1001 node_typescript_dev:
#	cd programming/fp01 && npm run dev
#
#step46_1002 node_fp_ts:
#	cd programming/fp01 && npm i fp-ts
#
#step46_1003 node_fp03_ts:
#	mkdir -p programming/fp03 && cd programming/fp03 && npm init -y && npm i create-fp-ts-lib  
#	cd programming/fp03 && ./node_modules/.bin/create-fp-ts-lib --packageManager npm -q  -n api_lib
#	cd programming/fp03/api_lib && npm i



step46_1200 node_typescript_clean:
	rm -rf programming
#####################################################

#####################################################
## dapp defi
step46_50 dapp_ui_init:
	cd dapp/defi_tutorial && npm i
#step10 web3-client:
#	npm i -g truffle
step46_52 web3_ganache_install:
	curl https://github.com/trufflesuite/ganache/releases/download/v2.5.4/ganache-2.5.4-linux-x86_64.AppImage; mv ganache-2.5.4-linux-x86_64.AppImage /usr/local/bin/; chmod +x /usr/local/bin/ganache-2.5.4-linux-x86_64.AppImage; ln -s /usr/local/bin//usr/local/bin/ganache-2.5.4-linux-x86_64.AppImage /usr/local/bin/ganache;
step46_53 web3_browser_metamask:
	echo 'Install metamask in google chrome https://metamask.io/download.html'
step46_54 web3_ganache_run:
	cd dapp/defi_tutorial && ganache
step46_55 web3_truffle_install:
	cd dapp/defi_tutorial && npm i -D truffle 
step46_56 web3_compile_contracts:
	cd dapp/defi_tutorial && ./node_modules/.bin/truffle compile

#step13 web3-dbank:
#	curl https://github.com/dappuniversity/dbank/archive/refs/heads/starter_kit.zip; unzip dbank-starter_kit.zip
#step14 web3-npm-install:
#	cd dbank-starter_kit; npm i
#step17 web3-migrate:
#	cd dbank-starter_kit; truffle migrate
#step18 web3-test:
#	cd dbank-starter_kit; truffle test	
######################################################


#####################################################
## dapp
#step4550 dapp-ui-init:
#	cd dapp && npx create-react-app ui
#step4551 dapp-ui-ether:
#	cd dapp/ui && npm i ethers hardhat @nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers
#	cd dapp/ui && npm i dotenv
#	
#step4552 dapp-ui-ether-create:
#	cd dapp/ui && npx hardhat
#
#step4553 dapp-ui-ether-compile:
#	cd dapp/ui && npx hardhat compile
#
#step4554 dapp-ui-ether-node-local-network:
#	cd dapp/ui && npx hardhat node ## run owr own ethereum node
#
#step4555 dapp-ui-ether-run:
#	cd dapp/ui && npx hardhat run scripts/deploy.js --network localhost
#
#step4556 dapp-ui-ether-start:
#	cd dapp/ui && npm run start


#####################################################3
## app - neo4j - graphql - react - typescript
step4500 docker-system-prune:
	docker system prune -af	

step4501 graphql-ui-init:
	cd app && npm uninstall -g create-react-app && npx create-react-app ui --template typescript

step4502 graphql-compose-start:
	docker-compose -f docker/docker-compose.yml up --remove-orphans

step4503 docker-registry-start:
	docker run -d -p 5000:5000 --name registry -v /mnt/registry:/var/lib/registry registry:2
	docker pull alpine:3
	docker tag alpine:3 localhost:5000/dev_alpine
	docker push localhost:5000/dev_alpine
	# docker image remove alpine:3
	# docker image remove localhost:5000/dev_alpine
	# docker pull localhost:5000/dev_alpine

step4504 docker-registry-stop:
	docker container stop registry && docker container rm -v registry

step4505 graphql-api-init:
	cd app && npx create-express-typescript-application api -t plain
	cd app && cd api && npm i @neo4j/graphql graphql apollo-server neo4j-driver

#####################################################3
## server online alpine firewall - first steps
step4506 alpine_firewall: 
	apk update && apk upgrade
	apk add ip6tables iptables
	apk add -u awall
	apk version awall
step4507 alpine_kernel_load_module:
	modprobe -v ip_tables
	modprobe -v ip6_tables
	modprobe -v iptable_nat
	rc-update add iptables
	rc-update add ip6tables
#step4508 alpine_firewall_service_start:
#	ls -l /etc/iptables/
#	cat /etc/iptables/rules-save
#	rc-service iptables {start|stop|restart|status}
#	rc-service ip6tables {start|stop|restart|status}

step4509 alpine_firewall_cloud:
	cat <<EOF > /etc/awall/optional/cloud-server.json 
	{ 
	"description": "Default awall policy to protect Cloud server", 
	"variable": { "internet_if": "eth0" }, 
	"zone": { "internet": { "iface": "$internet_if" } }, 
	"policy": [ 
	{ "in": "internet", "action": "drop" }, 
	{ "action": "reject" } 
	] 
	} 
	EOF 

step4510 alpine_firewall_ssh:
	cat <<EOF > /etc/awall/optional/ssh.json 
	{ 
	"description": "Allow incoming SSH access (TCP/22)",
	"filter": [ 
	{ 
	"in": "internet", 
	"out": "_fw", 
	"service": "ssh", 
	"action": "accept", 
	"conn-limit": { "count": 3, "interval": 60 } 
	} 
	] 
	} 
	EOF 

step4511 alpine_firewall_ping:
	cat <<EOF > /etc/awall/optional/ping.json
	{
		"description": "Allow ping-pong",
		"filter": [
			{
				"in": "internet",
				"service": "ping",
				"action": "accept",
				"flow-limit": { "count": 10, "internal": 6 }
			}
		]
	}
	EOF

step4512 alpine_firewall_out:
	cat <<EOF > /etc/awall/optional/outgoing.json 
	{
		"description": "Allow outgoing connection for dns, http/https, ssh, ping",
		"filter": [
			{
				"in": "_fw",
				"out": "internet",
				"service": ["dns", "http", "https", "ssh", "ping", "ntp"],
				"action": "accept"
			}
		]
	}
	EOF

step4513 alpine_firewall_list:
	awall list
	#cloud-server  disabled  Default awall policy to protect Cloud server
	#outgoing      disabled  Allow outgoing connection for dns, http/https, ssh, ping
	#ping          disabled  Allow ping-pong
	#ssh           disabled  Allow incoming SSH access (TCP/22)


step4514 alpine_firewall_enable:
	awall enable cloud-server
	awall enable ssh
	awall enable ping
	awall enable outgoing

step4515 alpine_firewall_activate:
	awall activate

step4516 alpine_firewall_http:
	cat <<EOF > /etc/awall/optional/http.json
	{
		"description": "Allow incoming http/https (tcp/80 and 443) ports",
		"filter": [
			{
				"in": "internet",
				"out": "_fw",
				"service": [ "http", "https" ],
				"action": "accept"
			}
		]
	}
	EOF
	awall enable http
	awall activate

step4517 alpine_firewall_iptable_list:
	iptables -S
	ip6tables -S

step4518 alpine_firewall_dropped_log:
	dmesg | grep -w DPT=22

step4519 alpine_firewall_disable_reset_awall:
	rc-service iptables stop
	rc-service ip6tables stop
	awall disable cloud-server
	awall disable ssh
	awall disable ping
	awall disable outgoing
	awall disable http
	rc-update del ip6tables
	rc-update del iptables
#####################################################3


#step4403 docker-psql-ls:
#	docker exec docker_db_1 psql -Upostgres -d postgres -c '\l'	
#
#step4403-t docker-psql-ls-twitter:
#	docker exec docker_db_1 psql -Upostgres -d twitter-clone -c '\l'	

#step4404 docker-psql-exec-sql:
#	docker exec docker_db_1 psql -Upostgres -d postgres --file=/sql/input.sql > docker/sql/output.sql

#step4405 docker-pg_dump:
#	docker exec docker_db_1 pg_dump -Upostgres -d twitter_clone > docker/sql/create_tables.sql

#step4406 api-prisma-generate:
#	cd twitter-clone/api && npx prisma generate
#
#step4407 api-prisma-migrate-dev:
#	cd twitter-clone/api && npx prisma migrate dev --name init
#
#step4408 api-prisma-migrate-up:
#	cd twitter-clone/api && npx prisma migrate resolve --applied 20210615195142_init
#
#step4409 api-prisma-introspect: 
#	cd twitter-clone/api && npx prisma introspect ## check prisma - db
#
#step4410 api-npm-prisma-update: 
#	cd twitter-clone/api && npm i -D prisma && npm i @prisma/client 

#step4411 docker-psql-drop-database:
#	docker exec docker_db_1 psql -Upostgres -d postgres -c "DROP DATABASE twitter_clone;"	


#step01 app: ## Nestjs - GraphQL
#	mkdir app	
#step02 api-create: app
#	cd app && nest new api
#step03 api-install:
#	cd app/api && npm install @nestjs/graphql graphql-tools graphql apollo-server-express class-validator uuid
#step04 generate-types:
#	cd app/api && ./node_modules/.bin/ts-node src/scripts/generate.ts
#step05 api-test:
#	curl -X POST http://localhost:4000/graphql -H "Content-Type: application/json" -d '{ "query":"query { article(  id: 1 ){ id, title, content } }"}'

#ssh-manual-root-update: ## debian - dev-user:staff /usr/loca/bin
#	apt -y update; apt -y upgrade;
#	adduser dev-user; 
# usermod -g ssh dev-user; 
#	usermod -g staff dev-user;
# chown root:staff /usr/local/bin; chmod 775 /usr/local/bin;
# hostname [dev.domain];

step10 ssh-docker-install: ## debian - docker install
	$(foreach server, $(servers),  ssh root@$(server)	" apt -y install apt-transport-https software-properties-common ca-certificates curl gnupg lsb-release; echo  'deb [arch=amd64] https://download.docker.com/linux/debian  buster stable' | tee /etc/apt/sources.list.d/docker.list > /dev/null ;  curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - ; add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" ; apt -y update; apt -y remove docker docker-engine docker.io containerd runc; apt -y install docker-ce docker-ce-cli containerd.io; usermod -aG docker $(user) " \ ;)

step20 ssh-login:
	$(foreach server, $(servers),  ssh-copy-id  $(user)@$(server);)
	
step21 ssh-ls:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ls -a";)

step22 ssh-docker-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "docker run hello-world";)


#step23 ssh-k3d-install:
#	$(foreach server, $(servers),  ssh root@$(server) "curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash";)
	
#step24 ssh-k3d-test:
#	$(foreach server, $(servers),  ssh $(user)@$(server) "k3d --help;";)

#kubectl-version!=curl -L -s https://dl.k8s.io/release/stable.txt
#step25 ssh-kubectl-install:
#	$(foreach server, $(servers),  ssh root@$(server) "curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg; curl -LO 'https://dl.k8s.io/release/$(kubectl-version)/bin/linux/amd64/kubectl'; install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl;";)

#step26 ssh-kubectl-test:
#	$(foreach server, $(servers),  ssh $(user)@$(server) "kubectl version";)

#step30 ui-create:
#	mkdir ui; cd ui; npm init -y; mkdir public; mkdir src; touch public/index.html; \
#	npm i -D typescript webpack webpack-cli http-server react react-dom @types/react @types/react-dom; \
#	npx tsc --init ;\
#	echo 'UI - Created - React Typescript';

## SSH Multi Server commands execute 
step100 ssh-arkade:
	$(foreach server, $(servers),  ssh $(user)@$(server) "curl -sLS https://dl.get-arkade.dev | sh";)

step101 ssh-ark-kubectl:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ark get kubectl; mv ./.arkade/bin/kubectl /usr/local/bin/;";)

step102 ssh-kubectl-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "kubectl version";)

step103 ssh-ark-k3d:
	$(foreach server, $(servers),  ssh $(user)@$(server) "ark get k3d; mv ./.arkade/bin/k3d /usr/local/bin/;";)

step104 ssh-k3d-test:
	$(foreach server, $(servers),  ssh $(user)@$(server) "k3d version";)

## Default usage k3d - kubernetes cluster fast, simple, minimal
k3d-cluster-create:
	k3d cluster create
kubectl-cluster-info:
	kubectl cluster-info
k3d-cluster-delete:
	k3d cluster delete

## Kubernetes - interaction - cleaning
step150 kubectl-get-nodes:
	kubectl get nodes
step151 kubectl-get-sc:
	kubectl get sc
step152 kubectl-top-nodes:
	kubectl top nodes
step153 kubectl-kube-system-top-nodes:
	kubectl -n kube-system top nodes
step154 kubectl-get-componentstatus:
	kubectl get componentstatus

step170 kubectl-run-busybox:
	kubectl run -it --rm shell1 --image busybox

step171 docker-haproxy-sh:
	docker run -it haproxy:alpine /bin/sh
	
step180 kubectl-watch-get-pods:
	watch kubectl get pods -o wide

step190 kubectl-delete-all:
	kubectl delete all --all # delete all resources in all namespaces
