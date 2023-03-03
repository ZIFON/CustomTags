#include <sourcemod>

// Путь к файлу, где хранятся Steam ID и соответствующие им теги

#define TAGS_FILE "addons/sourcemod/configs/tags.cfg"

// Функция для загрузки Steam ID и соответствующих им тегов

void LoadTags()

{

    new file = fopen(TAGS_FILE, "r");

    if (!file)

    {

        LogError("Failed to load tags file %s", TAGS_FILE);

        return;

    }

    while (!feof(file))

    {

        new line[128], steamid[32], tag[32];

        // Чтение строки вида "STEAM_X:Y:ZZZZZZZZZ  tag"

        fscanf(file, "%s %s", steamid, tag);

        // Парсинг Steam ID в 64-битный целочисленный формат

        new steamid64 = GetSteamAccountID(steamid);

        // Установка тега

        SetUserTag(steamid64, tag);

    }

    fclose(file);

}

// Функция для выдачи тега

void GiveTag(int client, const char[] tag)

{

    SetUserTag(client, tag);

    ClientPrint(client, print_chat, "Ваш тег был изменен на %s", tag);

}

// Обработчик команды в консоли

void Cmd_GiveTag(int client, const char[] args)

{

    if (args[0] == '\0')

    {

        ClientPrint(client, print_chat, "Использование: sm_givetag <steamid> <tag>");

        return;

    }

    // Разбивка аргументов на Steam ID и тег

    new steamid[32], tag[32];

    sscanf(args, "%s %s", steamid, tag);

    new steamid64 = GetSteamAccountID(steamid);

    if (!steamid64)

    {

        ClientPrint(client, print_chat, "Неверный Steam ID");

        return;

    }

    GiveTag(steamid64, tag);

    ClientPrint(client, print_chat, "Тег выдан!");

}

// Инициализация плагина

void PluginInit()

{

    LoadTags();

    RegConsoleCmd("sm_givetag", Cmd_GiveTag, "Выдать тег по Steam ID");

}
