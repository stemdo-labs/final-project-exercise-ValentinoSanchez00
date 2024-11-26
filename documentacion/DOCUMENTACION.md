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
Aquí está toda la infraestructura usada para el proyecto, consta de 16 recursos

![image](https://github.com/user-attachments/assets/7aa3855c-5ccf-4637-a727-8a373f8d7710)

Los mas principales son:
- 2 vnets (cada una con su subnet)
- 2 peering
- 2 interfaces de red
- 1 cluster
- 1 registro de contenedores
- 2 contenedores
- 1 security group
- 2 maquinas virtuales

Vamos a hablar de los 2 repos subyacentes

## Frontend
En el primer repo subyacente encontramos la estructura de una pagina web con el dockerfile para que la ponga en un contenedor y unos workflow que utilizan los reusables del flujo principal 
aqui esta implementado un CI/CD mediante dispach, lo hablaremos mas adelante cuando hable del flujo

![image](https://github.com/user-attachments/assets/9e54e489-0798-4a81-bfbd-3c8853fbd421)


## Backend

En el primer repo subyacente encontramos la estructura de un backend con el dockerfile para que la ponga en un contenedor y unos workflow que utilizan los reusables del flujo principal 
aqui esta implementado un CI/CD mediante dispach, lo hablaremos mas adelante cuando hable del flujo


![image](https://github.com/user-attachments/assets/4f483991-ef02-4fec-99ee-f215ae0d1596)


# Flujo

EL usuario deberá iniciar la infraestructura haciendo un merge a main en el repo principal , así se hará un plan y un apply 
Tras esto debemos crear un runner en nuestra maquina de backups conectandonos por ssh y la ip pública, para ello vamos a settings -> actions -> runners y vamos a crear un nuevo runner

![image](https://github.com/user-attachments/assets/6306f320-89d1-420b-b8b2-da35509d11aa)


Ese condigo de comando lo copiamos en nuestra mv que va a ser nuestro runner, en nuestrop caso es la maquina virtual de backups
Una vez hecho ejecutamos los dispach en este orde : ansible, postgre
cunado se completen ya tendrás una bd llamada orquestas y un usuario vsanchez ( en mi caso, si quieres cambiarlo ve al código y cambialo)

Ahora nos vamos a los repos adyacentes :
Estos tienen un CD/CI a través de dispachs porque no he conseguido ver el flujo de una manera mas automatizada ya que cada flujo requiere inputs puestos manualmente

Ejecutamos SubirDockerfile.yaml y SubirChart.yaml , ambas tienen un imput llamado microservicio q por defecto es frontend, el usuario puede cambiarlo a como lo quiera llamar pero con la condición de que lo cambie en los demás . Estos suben los dockerfiles a el azr y los charts a el harbor proporcionado (CI) 
Posteriormente ejecutaríamos el principal.yaml (CD)  que tiene dos imputs , el de microservicios y la version del chart, el de microservicio es el mencionado anteriormente y la version del chart es la versión subida que queramos ejecutar. Este flujo recoge el dockerfile y el chart propio y depliega el front o back en el cluster


# Fallos y cosas a mejorar















