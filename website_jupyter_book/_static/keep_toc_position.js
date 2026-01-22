document.addEventListener("DOMContentLoaded", () => {
  const sidebar = document.querySelector(".bd-sidebar");

  if (!sidebar) return;

  // Restore previous scroll position
  const saved = sessionStorage.getItem("toc-scroll");
  if (saved !== null) {
    sidebar.scrollTop = parseInt(saved, 10);
  }

  // Save scroll position on scroll
  sidebar.addEventListener("scroll", () => {
    sessionStorage.setItem("toc-scroll", sidebar.scrollTop);
  });
});

