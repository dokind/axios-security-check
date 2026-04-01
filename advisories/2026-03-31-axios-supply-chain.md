# 🚨 Axios NPM Supply Chain Халдлага — 2026-03-31

**Ангилал:** Supply Chain Attack  
**Нөлөөлсөн хувилбарууд:** `axios@1.14.1`, `axios@0.30.4`  
**Статус:** ✅ Шийдэгдсэн  
**Аюулгүй хувилбарууд:** `axios@1.14.0`, `axios@0.30.3`

---

## 📋 Тойм

2026 оны 3 дугаар сарын 31-нд `axios` NPM package-д supply chain халдлага илэрсэн.
Хортой код нь `plain-crypto-js` хэмээх шинэ dependency нэмж, хэрэглэгчийн credential болон
environment variable-уудыг алсын C2 серверт (IP: `142.11.206.73`) дамжуулдаг байв.

---

## 🎯 Нөлөөлсөн хувилбарууд

| Package | Хортой хувилбар | Аюулгүй хувилбар |
|---|---|---|
| axios | 1.14.1 | 1.14.0 |
| axios | 0.30.4 | 0.30.3 |

---

## 🔍 Халдлагын дэлгэрэнгүй

### Хортой dependency

Хортой `axios` хувилбарууд нь `plain-crypto-js` гэсэн package-ийг dependency болгон нэмсэн.
Энэ package нь хэрэглэгчийн:

- `process.env` дахь бүх environment variable
- `~/.npmrc` файлаас npm token
- SSH private key болон config файлууд

...зэргийг цуглуулж, шифрлэн C2 серверт илгээдэг.

### C2 сервер

- **IP хаяг:** `142.11.206.73`
- **Порт:** 443 (HTTPS дуурайсан)

---

## ⚡ Яаралтай арга хэмжээ

### 1. Халдлагад өртсөн эсэхийг шалга

```bash
# Хортой package байгаа эсэхийг шалга
grep "plain-crypto-js" package-lock.json
find node_modules -name "plain-crypto-js" -type d

# C2 server-тэй холбогдсон эсэхийг шалга
netstat -an | grep "142.11.206.73"

# Хортой axios хувилбар суусан эсэхийг шалга
npm list axios
```

### 2. Хортой хувилбар ашиглаж байгаа бол

```bash
# Аюулгүй хувилбар руу шилж
npm install axios@1.14.0
# эсвэл
npm install axios@0.30.3

# node_modules-ийг бүрэн цэвэрлэ
rm -rf node_modules package-lock.json
npm install
```

### 3. Credential-уудаа шинэчил

Хортой хувилбар ашигласан бол **заавал** дараах credential-уудаа өөрчил:

- NPM token (`npm token revoke` + шинэ token үүсгэ)
- GitHub Personal Access Token
- Environment variable дахь API key, нууц үг
- SSH private key (шинэ key үүсгэж, public key-ийг сервер дээр шинэчил)

### 4. Автомат шалгалтын script ажиллуул

```bash
chmod +x ./scripts/check-axios-attack.sh
./scripts/check-axios-attack.sh
```

---

## 🛡️ Урьдчилан сэргийлэх арга

1. **`package-lock.json` эсвэл `yarn.lock` файлыг lock хий** — dependency version-ийг тогтмол байлга
2. **Автоматаар шинэчлэлт идэвхгүй болго** — `npm audit` тогтмол ажиллуул
3. **CI/CD pipeline-д `npm audit` нэм** — шинэ vulnerability гарсан даруй мэдэгдэнэ
4. **Supply chain хамгаалалт ашигла** — [Socket.dev](https://socket.dev) зэрэг хэрэгсэл ашигла

---

## 📎 Нэмэлт эх сурвалж

- [NPM Advisory Database](https://github.com/advisories)
- [Socket Security Blog](https://socket.dev/blog)
- [OpenSSF Supply Chain Security](https://openssf.org)

---

*Энэ advisory нь [mongolia-dev-security](../) репо-д нийтлэгдсэн.*
