/**
 * Canary - A free and open-source MMORPG server emulator
 * Copyright (©) 2019–present OpenTibiaBR <opentibiabr@outlook.com>
 * Repository: https://github.com/opentibiabr/canary
 * License: https://github.com/opentibiabr/canary/blob/main/LICENSE
 * Contributors: https://github.com/opentibiabr/canary/graphs/contributors
 * Website: https://docs.opentibiabr.com/
 */

#pragma once

#include "declarations.hpp"

// TODO: move to .cpp for avoid circular dependencies
#include "config/configmanager.hpp"
#include "map/house/house.hpp"
#include "items/item.hpp"
#include "map/map.hpp"
#include "creatures/monsters/spawns/spawn_monster.hpp"
#include "creatures/npcs/spawns/spawn_npc.hpp"
#include "game/zones/zone.hpp"

class IOMap {
public:
	static void loadMap(Map* map, const Position &pos = Position());

	/**
	 * Load main map monsters
	 * \param map Is the map class
	 * \returns true if the monsters spawn map was loaded successfully
	 */
	static bool loadMonsters(Map* map) {
		if (map->monsterfile.empty()) {
			// OTBM file doesn't tell us about the monsterfile,
			// Lets guess it is mapname-monster.xml.
			map->monsterfile = g_configManager().getString(MAP_NAME);
			map->monsterfile += "-monster.xml";
		}

		return map->spawnsMonster.loadFromXML(map->monsterfile);
	}

	/**
	 * Load main map zones
	 * \param map Is the map class
	 * \returns true if the zones spawn map was loaded successfully
	 */
	static bool loadZones(Map* map) {
		if (map->zonesfile.empty()) {
			// OTBM file doesn't tell us about the zonesfile,
			// Lets guess it is mapname-zone.xml.
			map->zonesfile = g_configManager().getString(MAP_NAME);
			map->zonesfile += "-zones.xml";
		}

		return Zone::loadFromXML(map->zonesfile);
	}

	/**
	 * Load main map npcs
	 * \param map Is the map class
	 * \returns true if the npcs spawn map was loaded successfully
	 */
	static bool loadNpcs(Map* map) {
		if (map->npcfile.empty()) {
			// OTBM file doesn't tell us about the npcfile,
			// Lets guess it is mapname-npc.xml.
			map->npcfile = g_configManager().getString(MAP_NAME);
			map->npcfile += "-npc.xml";
		}

		return map->spawnsNpc.loadFromXml(map->npcfile);
	}

	/**
	 * Load main map houses
	 * \param map Is the map class
	 * \returns true if the main map houses was loaded successfully
	 */
	static bool loadHouses(Map* map) {
		if (map->housefile.empty()) {
			// OTBM file doesn't tell us about the housefile,
			// Lets guess it is mapname-house.xml.
			map->housefile = g_configManager().getString(MAP_NAME);
			map->housefile += "-house.xml";
		}

		return map->houses.loadHousesXML(map->housefile);
	}

	/**
	 * Load custom  map monsters
	 * \param map Is the map class
	 * \returns true if the monsters spawn map custom was loaded successfully
	 */
	static bool loadMonstersCustom(Map* map, const std::string &mapName, int customMapIndex) {
		const auto monsterFile = map->monsterfile.empty() ? (mapName + "-monster.xml") : map->monsterfile;
		auto &spawnContainer = map->spawnsMonsterCustomMaps[customMapIndex];

		g_logger().debug(
			"[IOMap::loadMonstersCustom] customIndex={} mapBase='{}' resolvedMonsterFile='{}' loaded={} started={}",
			customMapIndex,
			mapName,
			monsterFile,
			spawnContainer.isLoaded(),
			spawnContainer.isStarted()
		);

		// Defensive: if the same slot already got used (order-dependent scenarios),
		// don't silently skip loading due to SpawnsMonster::loadFromXML() guard.
		if (spawnContainer.isLoaded() || spawnContainer.isStarted()) {
			g_logger().debug(
				"[IOMap::loadMonstersCustom] resetting spawn container for customIndex={} before loading '{}'",
				customMapIndex,
				monsterFile
			);
			spawnContainer.clear();
		}

		const bool loaded = spawnContainer.loadFromXML(monsterFile);
		g_logger().debug(
			"[IOMap::loadMonstersCustom] customIndex={} file='{}' result={} spawnCount={}",
			customMapIndex,
			monsterFile,
			loaded,
			spawnContainer.getspawnMonsterList().size()
		);

		return loaded;
	}

	/**
	 * Load custom  map zones
	 * \param map Is the map class
	 * \returns true if the zones spawn map custom was loaded successfully
	 */
	static bool loadZonesCustom(Map* map, const std::string &mapName, int customMapIndex) {
		if (map->zonesfile.empty()) {
			// OTBM file doesn't tell us about the zonesfile,
			// Lets guess it is mapname-zones.xml.
			map->zonesfile = mapName;
			map->zonesfile += "-zones.xml";
		}
		return Zone::loadFromXML(map->zonesfile, customMapIndex);
	}

	/**
	 * Load custom map npcs
	 * \param map Is the map class
	 * \returns true if the npcs spawn map custom was loaded successfully
	 */
	static bool loadNpcsCustom(Map* map, const std::string &mapName, int customMapIndex) {
		const auto npcFile = mapName + "-npc.xml";
		auto &spawnContainer = map->spawnsNpcCustomMaps[customMapIndex];

		g_logger().debug(
			"[IOMap::loadNpcsCustom] customIndex={} mapBase='{}' resolvedNpcFile='{}' loaded={} started={}",
			customMapIndex,
			mapName,
			npcFile,
			spawnContainer.isLoaded(),
			spawnContainer.isStarted()
		);

		// Custom maps must not reuse stale NPC spawn state from a previous map load.
		// Reset the slot before parsing the next file so multiple custom maps can coexist.
		if (spawnContainer.isLoaded() || spawnContainer.isStarted()) {
			g_logger().debug(
				"[IOMap::loadNpcsCustom] resetting spawn container for customIndex={} before loading '{}'",
				customMapIndex,
				npcFile
			);
			spawnContainer.clear();
		}

		const bool loaded = spawnContainer.loadFromXml(npcFile);
		g_logger().debug(
			"[IOMap::loadNpcsCustom] customIndex={} file='{}' result={} spawnCount={}",
			customMapIndex,
			npcFile,
			loaded,
			spawnContainer.getSpawnNpcList().size()
		);

		return loaded;
	}

	/**
	 * Load custom map houses
	 * \param map Is the map class
	 * \returns true if the map custom houses was loaded successfully
	 */
	static bool loadHousesCustom(Map* map, const std::string &mapName, int customMapIndex) {
		if (map->housefile.empty()) {
			// OTBM file doesn't tell us about the housefile,
			// Lets guess it is mapname-house.xml.
			map->housefile = mapName;
			map->housefile += "-house.xml";
		}
		return map->housesCustomMaps[customMapIndex].loadHousesXML(map->housefile);
	}

private:
	static void parseMapDataAttributes(FileStream &stream, Map* map);
	static void parseWaypoints(FileStream &stream, Map &map);
	static void parseTowns(FileStream &stream, Map &map);
	static void parseTileArea(FileStream &stream, Map &map, const Position &pos);
};

class IOMapException : public std::exception {
public:
	explicit IOMapException(std::string msg) :
		message(std::move(msg)) { }

	const char* what() const noexcept override {
		return message.c_str();
	}

private:
	std::string message;
};
