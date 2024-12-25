## Text

### Encode

```powershell
ConvertTo-Base64 -Encode "Hello World"
```

**logogram**

```powershell
ConvertTo-Base64 -e "Hello World"
```

> **Output:** SGVsbG8gV29ybGQ=

### Decode

```powershell
ConvertTo-Base64 -Decode "SGVsbG8gV29ybGQ="
```

**logogram**

```powershell
ConvertTo-Base64 -d "SGVsbG8gV29ybGQ="
```

> **Output:** Hello World

## Image

### Encode

```powershell
ConvertTo-Base64 -Encode -Image "your path\image.jpg"
```

**logogram**

```powershell
ConvertTo-Base64 -e -i "your path\image.jpg"
```

If you need to **save** the base64 of the output, use:

```powershell
ConvertTo-Base64 -e -i "your path\image.jpg" | Set-Content -Path "your path\base64.txt"
```

> **Output:** Picture of base64

### Decode

Since the base64 bytes of the image are **large**, please use a **txt** file to save it.

```powershell
ConvertTo-Base64 -Decode -Base64Txt "your path\txt file with base64 written.txt" -Output "your path\image.jpg"
```

**logogram**

```powershell
ConvertTo-Base64 -d -txt "your path\txt file with base64 written.txt" -o "your path\image.jpg"
```

> **Output:** View the image in your save path.
