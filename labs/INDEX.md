# Lab profiles

A **lab** is a real codebase a lesson can draw on for its optional real-world detour. Labs are
optional and pluggable: the core methodology and curriculum know nothing about any of them.

At session start the agent matches the user's current working directory against the `applies-to`
values below — but it loads the matching profile only if it actually takes the detour, which most
lessons do not.

| Profile | applies-to (working directory) | Language / stack |
|---|---|---|
| `nama-erp.md` | `C:\Projects\8080` | Java 21, Spring Boot 3.5, Hibernate 6, Maven monorepo |

## No match?

Run in **codebase-free mode**. A detour, if one is taken, uses a self-contained example the agent
writes itself, and it says once at the start that no lab is active. This is a fully supported mode — the system
works with this whole directory deleted.

## Adding a lab

Copy `TEMPLATE.md`, fill it in, and add a row above. Nothing else in the system needs to change.
