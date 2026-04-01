Here's the full README.md text — copy and paste this directly into GitHub:

markdown# 🛡️ Axios NPM Supply Chain Attack — Монгол Хөгжүүлэгчдэд Зориулсан Гарын Авлага

> **2026 оны 3-р сарын 31-нд** дэлхийд хамгийн өргөн хэрэглэгддэг JavaScript library болох **axios** (долоо хоногт 100 сая+ татагддаг) хакерт эзлэгдсэн. Хортой код нь суулгасны дараа **1.1 секундэд** ажиллаж эхэлдэг бөгөөд өөрийгөө устгадаг тул ямар ч ул мөр үлддэггүй.

---

## ⚡ Би өртсөн үү? (30 секундэд шалга)
```bash
npm list axios
npm list -g axios
```

| | Version |
|---|---|
| 🔴 **Хортой** | `axios@1.14.1` болон `axios@0.30.4` |
| ✅ **Аюулгүй** | `axios@1.14.0` болон `axios@0.30.3` |

---

## 🔍 Алхам алхмаар Шалгалт

### Алхам 1 — Системийн бүх axios-г скан хий

**Mac / Linux:**
```bash
find / -path "*/node_modules/axios/package.json" 2>/dev/null | while read f; do
  version=$(grep '"version"' "$f" | head -1)
  echo "$f -> $version"
done
```

**Windows (PowerShell):**
```powershell
Get-ChildItem -Path C:\ -Recurse -Filter "package.json" -ErrorAction SilentlyContinue |
  Where-Object { $_.DirectoryName -like "*node_modules\axios" } |
  ForEach-Object {
    $version = (Get-Content $_.FullName | Select-String '"version"').Line
    Write-Output "$($_.FullName) -> $version"
  }
```

> Хэрэв `1.14.1` эсвэл `0.30.4` гарч ирвэл — **та халдлагад өртсөн байна.**

---

### Алхам 2 — Lockfile-н түүх шалга
```bash
git log -p -- package-lock.json | grep "plain-crypto-js"
```

Хэрэв `plain-crypto-js` гарч ирвэл — шалгалтаа үргэлжлүүл. Жинхэнэ axios нь яг **3** dependency-тэй байдаг: `follow-redirects`, `form-data`, `proxy-from-env`. Өөр ямар нэг зүйл байвал — аюулын тэмдэг.

---

### Алхам 3 — Хортой файл байгаа эсэхийг шалга

**macOS:**
```bash
ls -la /Library/Caches/com.apple.act.mond 2>/dev/null
```

**Linux:**
```bash
ls -la /tmp/ld.py 2>/dev/null
```

**Windows (PowerShell):**
```powershell
Test-Path "$env:PROGRAMDATA\wt.exe"
Test-Path "$env:PROGRAMDATA\system.bat"
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" | Select-String "MicrosoftUpdate"
```

---

### Алхам 4 — C2 сервертэй холбогдсон эсэхийг шалга
```bash
netstat -an | grep "142.11.206.73"
```

**Windows (PowerShell):**
```powershell
Get-NetTCPConnection | Where-Object { $_.RemoteAddress -eq "142.11.206.73" }
```

Хэрэв юм гарч ирвэл — таны машин **одоо ч хакерын серверт холбогдсон байна.**

---

## 🚨 Өртсөн бол яах вэ

**Нэг файл устгаад дуусгах гэж бүү оролд — машинаа бүрэн эзлэгдсэн гэж үз.**

1. **Бүх credential-аа шууд солих**
   - npm token
   - SSH key
   - AWS / GCP / Azure key
   - GitHub Personal Access Token
   - Docker, Kubernetes config
   - Database нэвтрэх мэдээлэл

2. **C2 traffic блоклох** — `sfrclak.com` болон `142.11.206.73`-г firewall дээр хаа

3. **Хортой файлуудыг устга**

   macOS:
```bash
   rm /Library/Caches/com.apple.act.mond
```

   Linux:
```bash
   rm /tmp/ld.py
   # эсвэл зүгээр л restart хий — Linux дээр persistence байхгүй
```

   Windows:
```powershell
   Remove-Item "$env:PROGRAMDATA\wt.exe" -Force
   Remove-Item "$env:PROGRAMDATA\system.bat" -Force
   Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "MicrosoftUpdate"
```

4. **Аюулгүй version руу буц**
```bash
   npm install axios@1.14.0   # 1.x хэрэглэгчдэд
   npm install axios@0.30.3   # 0.x хэрэглэгчдэд
   npm cache clean --force
```

5. **CI/CD pipeline-аа шалга** — хортой хугацаанд ажилласан build-ийг дахин ажиллуул

---

## 🛡️ Дараагийн Удаа Яаж Хамгаалах

### 1. Шинэ package-ийг автоматаар татахгүй байх
```bash
npm config set min-release-age 3
```
Publish болсноос хойш 3 хоног болоогүй package-ийг татахгүй болно. Энэ нэг тохиргоо энэ халдлагыг бүрэн зогсоох байсан.

### 2. Postinstall script идэвхгүй болго
`.npmrc` файлдаа нэм:
```
ignore-scripts=true
```
Энэ халдлага бүхэлдээ postinstall script-ээс хамаарч байсан. Script байхгүй бол халдлага байхгүй.

### 3. Яг version-г pin хий
`.npmrc` файлдаа нэм:
```
save-exact=true
```
`^1.14.0` гэж бичихэд npm автоматаар `1.14.1` рүү upgrade хийдэг — энэ л халдлагын орц байсан.

### 4. CI/CD дээр `npm ci` хэрэглэ
```bash
npm ci          # npm install биш
```
Lockfile дээрх яг version-г суулгадаг. Гэнэтийн update байхгүй.

### 5. pnpm эсвэл bun ашиглахыг бод
Эдгээр package manager нь lifecycle script-ийг **default-aar ажиллуулдаггүй**. Энэ халдлага pnpm эсвэл bun дээр бүрэн амжилтгүй болох байсан.

### 6. Хамгаалалтын tool ашигла
- **[Socket.dev](https://socket.dev)** — шинэ dependency нэмэгдсэн эсэх, postinstall script байгаа эсэхийг илрүүлдэг. Энэ халдлагыг publish болсноос хойш 6 минутад илрүүлсэн.
- **Snyk**, **Dependabot** — security issue автоматаар мэдэгддэг.

---

## 📋 Халдлагын Дэлгэрэнгүй

| Алхам | Юу болсон |
|---|---|
| 1 | Хакер ерөнхий maintainer-н (`jasonsaayman`) npm token-ийг хулгайлсан |
| 2 | Account-н email-ийг `ifstap@proton.me` болгон өөрчилсөн |
| 3 | `package.json`-д нэг мөр нэмсэн: `"plain-crypto-js": "^4.2.1"` — кодоос хаана ч ашиглагддаггүй |
| 4 | Халдлагын өдрөөс 18 цагийн өмнө хуурамч "цэвэр" version publish хийсэн |
| 5 | GitHub Actions OIDC-г тойрч npm CLI-аар шууд publish хийсэн |
| 6 | `axios@1.14.1` болон `axios@0.30.4` — хоёулаа 39 минутын дотор хордогдсон |
| 7 | Postinstall dropper автоматаар ажилласан — XOR + Base64 obfuscation (key: `OrDeR_7077`) |
| 8 | Platform-тус бүрийн RAT 1.1 секундэд C2 серверээс татагдсан |
| 9 | Хортой программ өөрийгөө устгаж, цэвэр харагдах package.json-оор орлуулсан |

---

## 🔎 Indicators of Compromise (IOC)

| Төрөл | Утга |
|---|---|
| C2 Domain | `sfrclak.com` |
| C2 IP | `142.11.206.73` |
| C2 Port | `8000` |
| C2 Path | `/6202033` |
| XOR Key | `OrDeR_7077` |
| Хортой dependency | `plain-crypto-js@4.2.1` |
| Attacker email | `ifstap@proton.me`, `nrwise@proton.me` |

**Хортой файлын байршил:**

| OS | Байршил | Дүр эсгэсэн зүйл |
|---|---|---|
| macOS | `/Library/Caches/com.apple.act.mond` | Apple system cache |
| Windows | `%PROGRAMDATA%\wt.exe` | Windows Terminal |
| Linux | `/tmp/ld.py` | Ердийн temp файл |

**Хортой package SHA-1:**

| Package | SHA-1 |
|---|---|
| `axios@1.14.1` | `2553649f2322049666871cea80a5d0d6adc700ca` |
| `axios@0.30.4` | `d6f3f62fd3b9f5432f5782b62d8cfd5247d5ee71` |
| `plain-crypto-js@4.2.1` | `07d889e2dadce6f3910dcbc253317d28ca61c766` |

---

## ⏰ Халдлагын Цагийн Хуваарь

| UTC цаг | Болсон зүйл |
|---|---|
| 3-р сарын 30, 23:59 | `plain-crypto-js@4.2.1` хортой dropper-тэйгээр publish |
| 3-р сарын 31, 00:21 | `axios@1.14.1` publish, "latest" тэмдэглэгдсэн |
| 3-р сарын 31, 00:23 | Анхны халдлага — macOS, publish болсноос 89 секундэд |
| 3-р сарын 31, 00:58 | Windows-н анхны халдлага |
| 3-р сарын 31, 01:00 | `axios@0.30.4` publish, "legacy" тэмдэглэгдсэн |
| 3-р сарын 31, ~03:29 | Хортой package-ууд npm-ээс устгагдсан |

> **Монголоор:** 3-р сарын 31-ний өглөөний **08:21 – 11:29** (UTC+8) хооронд `npm install` хийсэн project-үүдийг онцгой анхааралтай шалга.

---

## 📺 Эх сурвалж

- [Huntress Blog](https://www.huntress.com/blog) — 100+ confirmed compromised hosts
- [Bitdefender Technical Advisory](https://www.bitdefender.com)
- [Socket.dev Analysis](https://socket.dev) — Анхны автомат илрүүлэлт (6 минутад)
- [GitHub Issue #10604](https://github.com/axios/axios/issues/10604) — Maintainer баталгаажуулсан
- [theNetworkChuck/axios-attack-guide](https://github.com/thenetworkchuck/axios-attack-guide) — Detection scripts

---

*Монгол хөгжүүлэгчдэд зориулсан кибер аюулгүй байдлын мэдээллийг цаашид нэмж байх болно. PR болон Issue нээхийг тавтай морилно уу.*

