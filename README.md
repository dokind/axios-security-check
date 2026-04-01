# 🛡️ mongolia-dev-security

**Монгол хөгжүүлэгчдэд зориулсан кибер аюулгүй байдлын нөөц**  
Cybersecurity resources for Mongolian developers

---

## 📌 Яагаад энэ repo?

Монгол хөгжүүлэгчид supply chain халдлага, npm аюулгүй байдал, credential хулгай зэрэг
аюулын талаар монгол хэлний нөөц маш цөөн байдаг. Энэ repo нь тэр цоорхойг нөхөх зорилготой.

---

## 🚨 Сүүлийн мэдэгдлүүд

| Огноо | Халдлага | Статус |
|---|---|---|
| 2026-03-31 | Axios NPM supply chain (axios@1.14.1, 0.30.4) | ✅ Шийдэгдсэн |

---

## 🔍 Axios NPM халдлага — Яаралтай шалгалт
```bash
# Хортой package байгаа эсэхийг шалга
grep "plain-crypto-js" package-lock.json
find node_modules -name "plain-crypto-js" -type d

# C2 server-тэй холбогдсон эсэхийг шалга
netstat -an | grep "142.11.206.73"
```

**Аюулгүй version руу буц:**
```bash
npm install axios@1.14.0
# эсвэл
npm install axios@0.30.3
```

→ [Дэлгэрэнгүй заавар](./advisories/2026-03-31-axios-supply-chain.md)

---

## 📚 Агуулга

- [`/advisories`](./advisories/) — Халдлагуудын дэлгэрэнгүй тайлбар (монгол)
- [`/checklists`](./checklists/) — Хөгжүүлэгчдэд зориулсан аюулгүй байдлын checklist
- [`/scripts`](./scripts/) — Шалгалтын автомат script-ууд

---

## 🤝 Хувь нэмэр оруулах

PR, Issue нээж болно. Монгол хэлний нөөц нэмэх хамгийн сайн.

---

## 📺 YouTube

[@dokind](https://youtube.com/@dokind) — Монгол хөгжүүлэгчдэд зориулсан security видео
