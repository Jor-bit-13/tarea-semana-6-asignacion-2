# Tarea Semana 6 — Asignación 2

**Seguridad de Redes · Laboratorio individual: Cisco AAA + Active Directory + NPS / RADIUS**

> 🎥 **VIDEO DEMOSTRATIVO (YouTube, máximo 10 minutos):** pendiente de agregar.
> **Estado:** autenticación/autorización de los niveles 0, 5 y 10 comprobada en R1 y SW1. Las imágenes deben encontrarse en `evidencias/` para verse dentro de esta página. Los running-config completos depurados y el video siguen pendientes.

## Propósito
Desplegar autenticación, autorización y contabilidad (AAA) centralizadas para un router y un switch Cisco en GNS3 mediante Windows Server AD DS y Network Policy Server (NPS) como servidor RADIUS. Los grupos de Active Directory controlan los niveles de privilegio 0, 5 y 10.

## Topología

```mermaid
flowchart TD
  R1["Router R1 · c2691<br/>Fa0/0 · 10.7.63.1/24"]
  SW1["Switch SW1 · c2691 EtherSwitch<br/>VLAN1 · 10.7.63.2/24"]
  C["Cloud1 · VMware VMnet3"]
  AD["Windows Server · lab.local<br/>AD DS + NPS · 10.7.63.10/24"]
  PC["PC1 · VPCS"]
  R1 -->|"Fa0/0 – Fa1/0"| SW1
  SW1 -->|"Fa1/1"| C
  SW1 -->|"Fa1/2"| PC
  C --> AD
```

Diagrama independiente: [diagramas/topologia.svg](diagramas/topologia.svg). El c2691 empleado como SW1 tiene un módulo EtherSwitch; no es la imagen vIOS-L2.

## Direccionamiento
| Equipo | Dirección IPv4 | Función |
| --- | --- | --- |
| R1 | `10.7.63.1/24` | Cliente RADIUS |
| SW1 | `10.7.63.2/24` | Cliente RADIUS / VLAN 1 |
| Windows Server | `10.7.63.10/24` | AD DS y NPS |
| Red de laboratorio | `10.7.63.0/24` | VMware VMnet3 |
| RADIUS | UDP 1812 / 1813 | Autenticación / contabilidad |

## Grupos y privilegios
| Usuario de dominio | Grupo Active Directory | Política NPS | Atributo Cisco |
| --- | --- | --- | --- |
| `usuario0` | `NET-NIVEL-0` | `POLITICA-NIVEL-0` | `shell:priv-lvl=0` |
| `usuario5` | `NET-NIVEL-5` | `POLITICA-NIVEL-5` | `shell:priv-lvl=5` |
| `usuario10` | `NET-NIVEL-10` | `POLITICA-NIVEL-10` | `shell:priv-lvl=10` |

En las políticas NPS se utiliza **Cisco-AV-Pair**, no un atributo `Vendor-Specific` genérico mal formado.

## Evidencia de pruebas
| Comprobación | R1 | SW1 |
| --- | --- | --- |
| RADIUS Access-Accept | Confirmado | Confirmado |
| Privilegio 0 | Cisco AVPair + autorización EXEC | Cisco AVPair + autorización EXEC |
| Privilegio 5 | `show privilege` = 5 | `show privilege` = 5 |
| Privilegio 10 | `show privilege` = 10 | Probado en sesión; captura pendiente de subir |
| SSH con usuario local `adminlocal` | Confirmado | Confirmado |
| Accesos consola | AAA configurado y probado | AAA configurado y probado |
| Línea AUX | Detectada / configuración mostrada | Detectada; captura de configuración completa pendiente |
| Logs de autenticación y contabilidad | Registrados | Registrados |

**El `show privilege` no está disponible por defecto en nivel 0**; por eso su evidencia es el paquete `Access-Accept`, `Cisco AVpair [1] "shell:priv-lvl=0"` y la autorización EXEC exitosa.

## Organización
- [docs/informe-tecnico.md](docs/informe-tecnico.md): informe de implementación, pruebas, correcciones, límites y conclusiones.
- [diagramas/](diagramas/): diagrama editable y SVG.
- [configuraciones/](configuraciones/): fragmentos sanitizados **NO equivalentes a running-config completos**.
- [scripts/verificar-ad-nps.ps1](scripts/verificar-ad-nps.ps1): verificaciones de solo lectura en Windows.
- [evidencias/INDICE.md](evidencias/INDICE.md): listado de capturas para incorporar.


## Evidencias visuales integradas

Las siguientes capturas corresponden a las pruebas realizadas en el laboratorio. Las imágenes no muestran contraseñas ni secretos compartidos. Si alguna no se visualiza, comprobar que el PNG correspondiente exista en `evidencias/`.

### Topología y conectividad

![Topología GNS3: R1, SW1, Cloud1 y equipo de prueba](evidencias/01_topologia_gns3.png)

*Topología GNS3: R1, SW1, Cloud1 y equipo de prueba.*

### Identidades de dominio

![Usuarios y grupos de Active Directory](evidencias/02_usuarios_grupos_AD.png)

*Usuarios y grupos de Active Directory.*

### Clientes NPS

![Clientes RADIUS registrados](evidencias/03_clientes_NPS.png)

*Clientes RADIUS registrados.*

### Servicio RADIUS

![Puertos UDP 1812 y 1813 escuchando en el servidor](evidencias/04_puertos_NPS.png)

*Puertos UDP 1812 y 1813 escuchando en el servidor.*

### Políticas de autorización

![Políticas de acceso NPS](evidencias/05_politicas_NPS.png)

*Políticas de acceso NPS.*

### Router R1: nivel 5

![R1, prueba de acceso con usuario de nivel 5](evidencias/06_R1_privilegio5.png)

*R1, prueba de acceso con usuario de nivel 5.*

### Router R1: nivel 10

![R1, Current privilege level is 10](evidencias/07_R1_privilegio10.png)

*R1, Current privilege level is 10.*

### Router R1: nivel 0

![R1, Access-Accept y Cisco AVPair nivel 0](evidencias/08_R1_privilegio0_radius.png)

*R1, Access-Accept y Cisco AVPair nivel 0.*

### Switch SW1: nivel 5

![SW1, Current privilege level is 5](evidencias/09_SW1_privilegio5.png)

*SW1, Current privilege level is 5.*

### Switch SW1: nivel 0

![SW1, autorización RADIUS de nivel 0](evidencias/10_SW1_privilegio0_radius.png)

*SW1, autorización RADIUS de nivel 0.*

### SW1: configuración

![SW1, fragmento visible de running-config](evidencias/11_SW1_running_config_parcial.png)

*SW1, fragmento visible de running-config.*

### SW1: estadísticas

![SW1, estadísticas RADIUS y versión SSH](evidencias/12_SW1_radius_stats.png)

*SW1, estadísticas RADIUS y versión SSH.*

### SW1: auditoría

![SW1, registro de eventos y autenticaciones](evidencias/13_SW1_logs.png)

*SW1, registro de eventos y autenticaciones.*

### R1: configuración

![R1, fragmento visible de running-config](evidencias/14_R1_running_config_parcial.png)

*R1, fragmento visible de running-config.*

### R1: controles de acceso

![R1, configuración de consola AUX y VTY](evidencias/15_R1_aux_y_vty.png)

*R1, configuración de consola AUX y VTY.*

### R1: auditoría

![R1, registros de accesos fallidos y exitosos](evidencias/16_R1_logs.png)

*R1, registros de accesos fallidos y exitosos.*

### R1: estadísticas

![R1, estadísticas RADIUS y SSH](evidencias/17_R1_radius_stats.png)

*R1, estadísticas RADIUS y SSH.*

### R1: interfaces

![R1, interfaz y direccionamiento IP](evidencias/18_R1_interfaces.png)

*R1, interfaz y direccionamiento IP.*

## Antes de entregar
Completar: **video al inicio de este README**, imágenes del paquete local, running-config íntegros depurados, evidencia final de AUX/SW1, fecha y hora de la demostración, relación entre IP y matrícula, y nombre reglamentario del TXT. La tarea es individual.

### Seguridad
Las contraseñas y secretos RADIUS expuestos durante el diagnóstico **no se publican**. Rotarlos antes de compartir el repositorio. IOS 12.4 y los algoritmos SSH heredados, así como PAP en esta práctica, corresponden a un laboratorio aislado y no a una configuración adecuada para producción.
