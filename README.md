# PoliGNU and PoliGEN Webserver deploy

## Testes

Antes é preciso instalar o Chef Kitchen

```gem install test-kitchen```

Para testar:

```kitchen test```

O kitchen vai usar o Vagrant pra criar uma VM e executará os testes nessa VM usando o Serverspec.

Depois de um teste de sucesso a VM é destruída. Depois de um teste que falhou, a VM não é destruída, assim podemos explorar melhor o problema.

Para logar na VM:

```kitchen login```

Para destruir a VM:

```kitchen destroy```

Para testar sem destruir a VM, mesmo em caso de sucesso:

```kitchen verify```

Usar o ```verify``` é uma boa ideia para acelerar o ciclo de teste-desenvolvimento, evitando a espera do tempo de criação da VM. Claro que dependendo de sua alteração na receita, a recriação da VM pode ser necessária.

Estados de uma VM criada pelo kitchen: ```created``` (VM criada com Vagrant), ```converged``` (Chef executado) e ```verified``` (testes executados) . 

Para verificar o estado da VM:

```kitchen list```
