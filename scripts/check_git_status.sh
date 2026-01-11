#!/bin/bash
cd /Users/kassyimbadollou/Documents/gegeDot

echo "=== REMOTES CONFIGURÉS ==="
git remote -v

echo ""
echo "=== DERNIERS COMMITS LOCAUX ==="
git log --oneline -10

echo ""
echo "=== STATUT DU DÉPÔT ==="
git status

echo ""
echo "=== COMMITS NON PUSHÉS (si remote configuré) ==="
git log origin/main..HEAD --oneline 2>/dev/null || echo "Remote 'origin' non configuré ou branche 'main' non trouvée"

echo ""
echo "=== BRANCHE ACTUELLE ==="
git branch --show-current
