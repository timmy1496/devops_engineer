.PHONY: help init plan apply destroy ansible-deploy ansible-monitoring ansible-webserver verify clean

# ─── Variables ───────────────────────────────────────────────────────────────
TF_DIR     := terraform
ANS_DIR    := ansible
INV        := $(ANS_DIR)/inventory/hosts.ini

# ─── Colors ──────────────────────────────────────────────────────────────────
GREEN  := \033[0;32m
YELLOW := \033[0;33m
RED    := \033[0;31m
NC     := \033[0m

help: ## Show this help
	@echo ""
	@echo "$(GREEN)Monitoring Stack — Terraform + Ansible$(NC)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-25s$(NC) %s\n", $$1, $$2}'
	@echo ""

# ─── Terraform ────────────────────────────────────────────────────────────────
init: ## Initialize Terraform
	@echo "$(GREEN)▶ Initializing Terraform...$(NC)"
	cd $(TF_DIR) && terraform init

plan: ## Preview infrastructure changes
	@echo "$(GREEN)▶ Planning infrastructure...$(NC)"
	cd $(TF_DIR) && terraform plan -out=tfplan

apply: ## Deploy AWS infrastructure
	@echo "$(GREEN)▶ Applying Terraform changes...$(NC)"
	cd $(TF_DIR) && terraform apply tfplan
	@echo "$(GREEN)✅ Infrastructure deployed!$(NC)"
	@$(MAKE) tf-output

destroy: ## Destroy all AWS resources (DANGER!)
	@echo "$(RED)⚠️  WARNING: This will destroy ALL resources!$(NC)"
	@read -p "Type 'yes' to confirm: " confirm && [ "$$confirm" = "yes" ] || exit 1
	cd $(TF_DIR) && terraform destroy -auto-approve
	@echo "$(RED)💥 Infrastructure destroyed$(NC)"

tf-output: ## Show Terraform outputs
	@echo "$(GREEN)▶ Terraform outputs:$(NC)"
	cd $(TF_DIR) && terraform output

# ─── Ansible ─────────────────────────────────────────────────────────────────
wait-for-ssh: ## Wait until EC2 instances accept SSH connections
	@echo "$(YELLOW)⏳ Waiting for SSH on all hosts...$(NC)"
	cd $(ANS_DIR) && ansible all -m wait_for_connection \
		-a "delay=10 timeout=300" -i $(INV)

ansible-deploy: wait-for-ssh ## Deploy full stack (monitoring + webserver)
	@echo "$(GREEN)▶ Running full Ansible deployment...$(NC)"
	cd $(ANS_DIR) && ansible-playbook -i $(INV) site.yml
	@echo "$(GREEN)✅ Full deployment complete!$(NC)"
	@$(MAKE) urls

ansible-monitoring: wait-for-ssh ## Deploy only monitoring server
	@echo "$(GREEN)▶ Deploying monitoring stack...$(NC)"
	cd $(ANS_DIR) && ansible-playbook -i $(INV) site.yml --tags monitoring

ansible-webserver: wait-for-ssh ## Deploy only web server
	@echo "$(GREEN)▶ Deploying web server...$(NC)"
	cd $(ANS_DIR) && ansible-playbook -i $(INV) site.yml --tags webserver

ansible-ping: ## Ping all hosts
	cd $(ANS_DIR) && ansible all -m ping -i $(INV)

# ─── Full Deploy ──────────────────────────────────────────────────────────────
deploy: init plan apply ansible-deploy ## Full deploy: Terraform + Ansible
	@echo "$(GREEN)🎉 Monitoring stack fully deployed!$(NC)"
	@$(MAKE) urls

# ─── Verification ────────────────────────────────────────────────────────────
verify: ## Check all services are responding
	@echo "$(GREEN)▶ Verifying services...$(NC)"
	@MONITORING_IP=$$(cd $(TF_DIR) && terraform output -raw monitoring_server_public_ip); \
	WEBSERVER_IP=$$(cd $(TF_DIR) && terraform output -raw webserver_public_ip); \
	echo "  Prometheus:    $$(curl -s -o /dev/null -w '%{http_code}' http://$$MONITORING_IP:9090/-/ready)"; \
	echo "  Grafana:       $$(curl -s -o /dev/null -w '%{http_code}' http://$$MONITORING_IP:3000/api/health)"; \
	echo "  Loki:          $$(curl -s -o /dev/null -w '%{http_code}' http://$$MONITORING_IP:3100/ready)"; \
	echo "  Nginx:         $$(curl -s -o /dev/null -w '%{http_code}' http://$$WEBSERVER_IP:80/health)"; \
	echo "  Node Exporter: $$(curl -s -o /dev/null -w '%{http_code}' http://$$WEBSERVER_IP:9100/metrics)"

urls: ## Print service URLs
	@echo ""
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN) Service URLs$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@cd $(TF_DIR) && terraform output grafana_url
	@cd $(TF_DIR) && terraform output prometheus_url
	@echo "$(YELLOW) Grafana credentials: admin / Admin@Grafana2024!$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""

# ─── Cleanup ──────────────────────────────────────────────────────────────────
clean: ## Clean local Terraform files
	cd $(TF_DIR) && rm -f tfplan .terraform.lock.hcl
	cd $(TF_DIR) && rm -rf .terraform/
	rm -f $(ANS_DIR)/inventory/hosts.ini
	rm -f $(ANS_DIR)/group_vars/all.yml
