# res://scripts/reputation_manager.gd
extends Node

# Diccionario para almacenar la reputación de cada NPC
var npc_reputation = {}
# Valor inicial de reputación para cada NPC
const INITIAL_REPUTATION = 100
const MAX_REPUTATION = 100
const MIN_REPUTATION = 0

# Función para registrar un nuevo NPC
func register_npc(npc_name: String):
	if !npc_reputation.has(npc_name):
		npc_reputation[npc_name] = INITIAL_REPUTATION
		print("NPC ", npc_name, " registrado con reputación: ", INITIAL_REPUTATION)

# Función para modificar la reputación del NPC
func modify_reputation(npc_name: String, change: int):
	if npc_reputation.has(npc_name):
		npc_reputation[npc_name] += change
		npc_reputation[npc_name] = clamp(npc_reputation[npc_name], MIN_REPUTATION, MAX_REPUTATION)
		print("La reputación de ", npc_name, " es ahora: ", npc_reputation[npc_name])
	else:
		print("NPC ", npc_name, " no encontrado. Debes registrarlo primero.")

# Función para obtener la reputación actual de un NPC
func get_reputation(npc_name: String) -> int:
	if npc_reputation.has(npc_name):
		return npc_reputation[npc_name]
	else:
		print("NPC ", npc_name, " no encontrado.")
		return -1  # Retorna -1 si el NPC no está registrado

# Función para reiniciar la reputación de un NPC
func reset_reputation(npc_name: String):
	if npc_reputation.has(npc_name):
		npc_reputation[npc_name] = INITIAL_REPUTATION
		print("Reputación de ", npc_name, " reiniciada a: ", INITIAL_REPUTATION)
	else:
		print("NPC ", npc_name, " no encontrado.")
