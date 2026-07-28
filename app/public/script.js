// Food Delivery Menu - menu data
// In a real deployment this could come from an API (e.g. /api/menu),
// but is kept static here to match the demo exactly.

const menuItems = [
  { name: "Margherita Pizza", price: 299 },
  { name: "Veg Burger", price: 149 },
  { name: "Pasta Alfredo", price: 249 },
  { name: "French Fries", price: 99 }
];

function renderMenu(items) {
  const container = document.getElementById("menu-container");
  container.innerHTML = items
    .map(
      (item) => `
      <div class="menu-item">
        <span class="name">${item.name}</span>
        <span class="price">₹${item.price}</span>
      </div>
    `
    )
    .join("");
}

document.addEventListener("DOMContentLoaded", () => {
  renderMenu(menuItems);
});
