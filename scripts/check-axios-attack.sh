#!/usr/bin/env bash
# check-axios-attack.sh
# Axios NPM Supply Chain халдлагыг шалгах автомат script
# 2026-03-31 | mongolia-dev-security

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "======================================"
echo "  Axios Supply Chain Шалгалт"
echo "  mongolia-dev-security | 2026-03-31"
echo "======================================"
echo ""

FOUND_ISSUE=false

# 1. Хортой package байгаа эсэхийг шалга
echo "🔍 [1/4] plain-crypto-js package шалгаж байна..."
if grep -q "plain-crypto-js" package-lock.json 2>/dev/null; then
  echo -e "${RED}❌ АЮУЛ: package-lock.json дотор plain-crypto-js олдлоо!${NC}"
  FOUND_ISSUE=true
else
  echo -e "${GREEN}✅ package-lock.json-д plain-crypto-js байхгүй${NC}"
fi

if find node_modules -name "plain-crypto-js" -type d 2>/dev/null | grep -q .; then
  echo -e "${RED}❌ АЮУЛ: node_modules дотор plain-crypto-js олдлоо!${NC}"
  FOUND_ISSUE=true
else
  echo -e "${GREEN}✅ node_modules-д plain-crypto-js байхгүй${NC}"
fi

echo ""

# 2. Axios хувилбар шалга
echo "🔍 [2/4] Axios хувилбар шалгаж байна..."
AXIOS_VERSION=$(node -e "try { console.log(require('./node_modules/axios/package.json').version) } catch(e) { console.log('not-found') }" 2>/dev/null || echo "not-found")

if [ "$AXIOS_VERSION" = "not-found" ]; then
  echo -e "${YELLOW}⚠️  axios node_modules-д олдсонгүй (суугаагүй байж магадгүй)${NC}"
elif [ "$AXIOS_VERSION" = "1.14.1" ] || [ "$AXIOS_VERSION" = "0.30.4" ]; then
  echo -e "${RED}❌ АЮУЛ: Хортой axios хувилбар ($AXIOS_VERSION) олдлоо!${NC}"
  echo -e "${YELLOW}   Шийдэл: npm install axios@1.14.0 (эсвэл axios@0.30.3)${NC}"
  FOUND_ISSUE=true
else
  echo -e "${GREEN}✅ Axios хувилбар аюулгүй: $AXIOS_VERSION${NC}"
fi

echo ""

# 3. C2 сервертэй холболт шалга
echo "🔍 [3/4] C2 сервер (142.11.206.73) холболт шалгаж байна..."
if netstat -an 2>/dev/null | grep -q "142.11.206.73"; then
  echo -e "${RED}❌ АЮУЛ: C2 сервертэй идэвхтэй холболт олдлоо!${NC}"
  echo -e "${RED}   Яаралтай сүлжээний холболтоо тасла!${NC}"
  FOUND_ISSUE=true
else
  echo -e "${GREEN}✅ C2 сервертэй холболт олдсонгүй${NC}"
fi

echo ""

# 4. package.json дахь axios шалга
echo "🔍 [4/4] package.json шалгаж байна..."
if [ -f "package.json" ]; then
  PKG_AXIOS=$(node -e "
    const p = require('./package.json');
    const deps = { ...p.dependencies, ...p.devDependencies };
    console.log(deps['axios'] || 'not-found');
  " 2>/dev/null || echo "not-found")

  if [ "$PKG_AXIOS" = "not-found" ]; then
    echo -e "${YELLOW}⚠️  package.json-д axios dependency байхгүй${NC}"
  else
    echo "   package.json дахь axios version spec: $PKG_AXIOS"
    echo -e "${GREEN}✅ package.json шалгалт дууслаа${NC}"
  fi
else
  echo -e "${YELLOW}⚠️  package.json файл олдсонгүй (axios project биш байж магадгүй)${NC}"
fi

echo ""
echo "======================================"

if [ "$FOUND_ISSUE" = true ]; then
  echo -e "${RED}🚨 ДҮГНЭЛТ: Аюулгүй байдлын асуудал олдлоо!${NC}"
  echo ""
  echo "Дараах алхмуудыг хий:"
  echo "  1. npm install axios@1.14.0"
  echo "  2. rm -rf node_modules && npm install"
  echo "  3. NPM token болон бусад credential-уудаа шинэчил"
  echo "  4. ./advisories/2026-03-31-axios-supply-chain.md файлыг уншина уу"
else
  echo -e "${GREEN}✅ ДҮГНЭЛТ: Axios supply chain халдлага илэрсэнгүй${NC}"
fi

echo "======================================"
