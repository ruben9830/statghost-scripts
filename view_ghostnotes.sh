#!/bin/bash
# view_ghostnotes.sh - Open markdown-based NOC notes

NOTES_DIR="$HOME/ghostnotes"

if [ ! -d "$NOTES_DIR" ]; then
  echo "📁 Creating notes directory at $NOTES_DIR..."
  mkdir -p "$NOTES_DIR"
fi

echo "📝 Opening GhostOps Notes Folder..."
if ! xdg-open "$NOTES_DIR" >/dev/null 2>&1; then
  echo "📁 Your notes folder is ready at: $NOTES_DIR"
  echo "💡 Use: cd ~/ghostnotes && glow <file>.md"
fi

