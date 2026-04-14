#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-ecommerce-main-eks}"
AWS_REGION="${AWS_REGION:-us-east-1}"
ALB_ROLE_ARN="${ALB_ROLE_ARN:-arn:aws:iam::746227194679:role/AmazonEKSLoadBalancerControllerRole}"

echo "Updating kubeconfig..."
aws eks update-kubeconfig --region "$AWS_REGION" --name "$CLUSTER_NAME"

echo "Getting VPC ID..."
VPC_ID=$(aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --query "cluster.resourcesVpcConfig.vpcId" \
  --output text)

echo "Ensuring OIDC provider is associated..."
eksctl utils associate-iam-oidc-provider \
  --cluster "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --approve

echo "Ensuring aws-load-balancer-controller service account exists..."
kubectl get sa aws-load-balancer-controller -n kube-system >/dev/null 2>&1 || \
kubectl create serviceaccount aws-load-balancer-controller -n kube-system

echo "Annotating service account with IAM role..."
kubectl annotate serviceaccount aws-load-balancer-controller \
  -n kube-system \
  eks.amazonaws.com/role-arn="$ALB_ROLE_ARN" \
  --overwrite

echo "Adding Helm repo..."
helm repo add eks https://aws.github.io/eks-charts >/dev/null 2>&1 || true
helm repo update >/dev/null

echo "Installing/upgrading AWS Load Balancer Controller..."
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName="$CLUSTER_NAME" \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region="$AWS_REGION" \
  --set vpcId="$VPC_ID"

echo "Waiting for controller rollout..."
kubectl rollout status deployment/aws-load-balancer-controller -n kube-system --timeout=300s

echo "Checking webhook endpoints..."
kubectl get endpoints -n kube-system aws-load-balancer-webhook-service

echo "Bootstrap complete."