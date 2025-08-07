// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"


import GLightbox from 'glightbox';

document.addEventListener("DOMContentLoaded", () => {
  const lightbox = GLightbox({
    selector: '.glightbox'
  });
});
