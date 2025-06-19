const QRCode = require("qrcode");

function formatId(id) {
  if (/^\d{10}$/.test(id) && id.startsWith("0")) {
    // Thai phone number: 0812345678 => 0066812345678
    return "0066" + id.substring(1);
  }
  return id;
}

function tag(id, value) {
  const len = value.length.toString().padStart(2, "0");
  return `${id}${len}${value}`;
}

function generatePromptPayPayload(id, amount = null) {
  const payloadFormatIndicator = tag("00", "01");
  const pointOfInitiationMethod = tag("01", amount ? "12" : "11");

  // Merchant Account Info - Tag 29
  const guid = tag("00", "A000000677010111");
  const promptpayId = tag("01", formatId(id));
  const merchantAccountInfo = tag("29", guid + promptpayId);

  const countryCode = tag("58", "TH");
  const currencyCode = tag("53", "764");

  const amountTag = amount ? tag("54", amount.toFixed(2)) : "";
  const data = payloadFormatIndicator +
    pointOfInitiationMethod +
    merchantAccountInfo +
    countryCode +
    currencyCode +
    amountTag;

  // CRC (Checksum)
  const toCheck = data + "6304";
  const crc = crc16(Buffer.from(toCheck, "utf8"));
  return toCheck + crc;
}

function crc16(buffer) {
  let crc = 0xFFFF;
  for (const b of buffer) {
    crc ^= b << 8;
    for (let i = 0; i < 8; i++) {
      if ((crc & 0x8000) !== 0) {
        crc = (crc << 1) ^ 0x1021;
      } else {
        crc <<= 1;
      }
    }
    crc &= 0xFFFF;
  }
  return crc.toString(16).toUpperCase().padStart(4, "0");
}

// Example usage
const promptpayId = "0952640750"; // Your PromptPay ID (phone or national ID)
const amount = 1.00;

const payload = generatePromptPayPayload(promptpayId, amount);
console.log("Payload:", payload);

// Generate QR
QRCode.toFile("promptpay.png", payload, {
  errorCorrectionLevel: "M",
}, function (err) {
  if (err) throw err;
  console.log("QR Code generated: promptpay.png ✅");
});
