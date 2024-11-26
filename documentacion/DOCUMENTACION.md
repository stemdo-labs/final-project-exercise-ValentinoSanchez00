# Documentación

En esta documentación hablaré de los pasos que he dado para realizar este proyecto

# Resumen
Este proyecto trata de tener por un lado 2 mv (una la bd y otra la de backups) en una vnet y otra vnet con el cluster donde está almacenado el front y back. el objetibo es que el back conecte con la bd y podamos registrar 
cosas en ella a través del front

# Estructura

Este proyecto consta de 3 repos, el principal que es este y dos secundarios donde almacenamos el back y front 
[back](https://github.com/stemdo-labs/final-project-gestion-rrhh-backend-ValentinoSanchez00)
[front](https://github.com/stemdo-labs/final-project-gestion-rrhh-frontend-ValentinoSanchez00)

Hablamos de este repositorio primero y seguidamente de los otros repos

## Repositorio principal

Consta de 4 partes:

- Actions y workflows
- Playtbooks de ansible
- Charts de helm
- Infraestructura


### Actions y workflows
La mayoría de estos workflows son o dispach o reusables, los dispach es sobretodo cuando quiera levantar la infraestructura, descargar ansible en la maquina virtual de la misma vnet de la bd
y instalar postgres en la bd de la vnet mencionada. Pero también hay reusables que utilizan los otros repos para el flujo de trabajo suyos

Los tres workflows principales en este repo son:
- infraestructureapply
- infraestructureplan
- backup

Los de la infraestructuras son para que cuando se genere una pr se actibe el plan de la infra por si hay errores y cuando se cierre haga el aplpy
El backup realiza un backup de la bd cada 5h , está desabilitado por temas de limites de uso
También hay un workflow que baja la infraestructura por si necesitamos bajarla de manera automatica en vez de por comandos

SubirCharts y subirDockerfiles son dos reusables que se usan el los siguientes repos


### Playbooks de Ansible

Son playbooks llamados por workflows que cumplen diferentes funciones como instalar ansible, realizar el backup e instalar postgres.
Cada una cumple su función cuando es llamado yt lo realiza al host mencionado en el inventario.ini


### Charts De Helm

Tenemos dos, uno para el back y otro para el front, cada una con sus retrinciones y las imagenes usadas son imagenes que abarcan en el azr 
Cada uno tiene un deployment y un servicio como se ve en las siguientes imagenes:

![image](https://github.com/user-attachments/assets/c613b3a9-85f9-4b79-b636-dcb15c477ca2)  ![image](https://github.com/user-attachments/assets/f6f21290-a2cf-4916-8ec8-a01832991edd)


### iac 
Aquí está toda la infraestructura usada para el proyecto, consta de 16








