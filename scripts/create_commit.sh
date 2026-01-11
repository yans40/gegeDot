#!/bin/bash
cd "$(dirname "$0")/.."
git add frontend/hierarchical-tree-beta-fixed.html
git add backend/src/GegeDot.Services/DTOs/PersonDto.cs
git add backend/src/GegeDot.Services/Services/PersonService.cs
git commit -m "Approche hybride pour selection/creation des parents - Recherche avec autocompletion et creation rapide avec detection de doublons"
echo "Commit cree avec succes"
