# 🛡️ Хөгжүүлэгчийн Аюулгүй Байдлын Checklist

Монгол хөгжүүлэгчдэд зориулсан NPM болон supply chain аюулгүй байдлын checklist.

---

## 📦 NPM / Package Manager

- [ ] `package-lock.json` эсвэл `yarn.lock` файл repo-д байгаа эсэхийг шалга
- [ ] `npm audit` тогтмол ажиллуулж байна уу?
- [ ] CI/CD pipeline дотор `npm audit --audit-level=high` тохируулсан уу?
- [ ] Dependency-уудаа `npm outdated` ашиглан тогтмол шинэчилж байна уу?
- [ ] `npm install` хийхдээ `--ignore-scripts` ашиглаж байна уу? (postinstall script-ээс болгоомжил)
- [ ] `socket` эсвэл `snyk` зэрэг supply chain хамгаалалтын хэрэгсэл ашиглаж байна уу?

---

## 🔑 Credential ба Secret

- [ ] `.env` файл `.gitignore`-д орсон эсэхийг шалга
- [ ] Repo-д нууц үг, API key, token commit хийгээгүй эсэхийг шалга (`git log --all` шалга)
- [ ] NPM token `~/.npmrc`-д хадгалагдсан уу? (зөвхөн шаардлагатай үед ашигла)
- [ ] GitHub Personal Access Token-ийг зөвхөн шаардлагатай эрх (scope)-тэй үүсгэсэн үү?
- [ ] Environment variable-уудыг CI/CD platform-д аюулгүй хадгалсан уу?
- [ ] `gitleaks` эсвэл `truffleHog` ашиглан secret scan хийж байна уу?

---

## 🏗️ CI/CD Pipeline

- [ ] CI pipeline-д `npm audit` орсон уу?
- [ ] Dependency checkup автоматчилсан уу? (Dependabot, Renovate)
- [ ] Docker image-ийн base image-ийг тогтмол шинэчилж байна уу?
- [ ] CI/CD pipeline-д third-party action ашиглахдаа commit SHA pin хийсэн үү?

---

## 🌐 Сүлжээ ба Серверийн Аюулгүй Байдал

- [ ] Production server дээр шаардлагагүй порт хаалттай уу?
- [ ] Firewall тохируулсан уу?
- [ ] HTTPS бүх endpoint дээр идэвхтэй юу?
- [ ] API rate limiting тохируулсан уу?

---

## 🔍 Supply Chain Халдлагаас Хамгаалах

- [ ] Шинэ package нэмэхдээ эхлээд `npm audit` болон [socket.dev](https://socket.dev) дээр шалга
- [ ] Package-ийн `package.json` дахь `scripts` талбарыг заавал уншаад нэм
- [ ] Тогтмол `find node_modules -name "*.sh" -o -name "*.bat"` ажиллуулж байна уу?
- [ ] Ховор ашиглагддаг dependency-уудыг хуулбарлан (vendor) ашигла

---

## 📋 Incident Response

Халдлага илэрсэн тохиолдолд:

1. **Тусгаарла** — нөлөөлөлд өртсөн систем, token, credential-уудыг тэр даруй хааж блок хий
2. **Шалга** — `netstat`, `ps aux`, log файлуудыг шалга
3. **Мэдэгд** — багийн гишүүд болон хамааралтай талуудад мэдэгд
4. **Credential солих** — бүх нууц үг, token, key-ийг шинэчил
5. **Бичиглэ** — болсон явдлыг тодорхой бичиглэ, дараа нь урьдчилан сэргийлэх арга хэмжээ ав

---

*[mongolia-dev-security](../) репо-д дэлгэрэнгүй advisory болон script-ууд байна.*
