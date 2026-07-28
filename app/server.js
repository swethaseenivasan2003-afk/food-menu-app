const express = require("express");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static frontend files
app.use(express.static(path.join(__dirname, "public")));

// Health check endpoint - used by ALB target group health checks
app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

// Fallback to index.html for the root/any other route
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "index.html"));
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Food menu service running on port ${PORT}`);
});
