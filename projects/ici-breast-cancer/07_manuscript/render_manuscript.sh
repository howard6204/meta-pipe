#!/bin/bash
# Render TNBC ICI manuscript to multiple formats

set -e

echo "🔄 Rendering TNBC ICI Manuscript..."
echo ""

# Check if Quarto is installed
if ! command -v quarto &> /dev/null; then
    echo "❌ Error: Quarto is not installed"
    echo "Install from: https://quarto.org/docs/get-started/"
    exit 1
fi

# Check if references.bib exists
if [ ! -f "references.bib" ]; then
    echo "⚠️  Warning: references.bib not found"
    echo "Creating placeholder references.bib..."
    touch references.bib
fi

# Check if lancet.csl exists
if [ ! -f "lancet.csl" ]; then
    echo "⚠️  Warning: lancet.csl not found"
    echo "Downloading Lancet citation style..."
    curl -o lancet.csl https://raw.githubusercontent.com/citation-style-language/styles/master/the-lancet.csl
fi

# Create output directory
mkdir -p output

echo "📄 Rendering to PDF..."
quarto render index.qmd --to pdf --output-dir output

echo "📄 Rendering to DOCX..."
quarto render index.qmd --to docx --output-dir output

echo "📄 Rendering to HTML..."
quarto render index.qmd --to html --output-dir output

echo ""
echo "✅ Rendering complete!"
echo ""
echo "Output files:"
ls -lh output/
echo ""
echo "📖 Open manuscript:"
echo "  PDF:  output/index.pdf"
echo "  DOCX: output/index.docx"
echo "  HTML: output/index.html"
