alias k="kubectl"
alias kx="kubectx"
alias kn="kubens"

alias kfails='kubectl get po -owide --all-namespaces | grep "0/" | tee /dev/tty | wc -l'

alias ki="kubectl-inspect "

alias ked="EDITOR=vim kubectl edit " 

alias kexec="kubectl exec -it"

alias klogs="kubectl logs -f"

alias kdd="kubectl delete"

alias kg="kubectl get"
alias kgi="kubectl get ing"
alias kgp="kubectl get pods -o=wide"
alias kgpa="kubectl get pods -o=wide --all-namespaces"
alias kgs="kubectl get services"
alias kgd="kubectl get deploy"
alias kgh="kubectl get hpa"
alias kgss="kubectl get secrets"
alias kgep="kubectl get endpoints "

alias kd="kubectl describe"
alias kdp="kubectl describe pods $pod"

alias kds="kubcetl-secrets"
function kubcetl-secrets() {
  kubectl get secrets $@ -ojson | jq '{name: .metadata.name, data: .data | map_values(@base64d)}'
}
