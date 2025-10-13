# Assets Directory

This directory contains static assets and resources used throughout the application.

## Purpose

The assets directory stores:
- **Font files** for typography
- **Icon libraries** for UI elements
- **Image assets** for branding and UI
- **CSS frameworks** and stylesheets
- **JavaScript libraries** for client-side functionality
- **Document templates** for reports and exports

## Structure

```
assets/
├── fonts/                     # Font files
│   ├── roboto/               # Roboto font family
│   ├── open-sans/            # Open Sans font family
│   └── custom/                # Custom fonts
├── icons/                     # Icon libraries
│   ├── material-icons/        # Material Design icons
│   ├── font-awesome/          # Font Awesome icons
│   └── custom/                # Custom icons
├── images/                    # Image assets
│   ├── logos/                # Company and product logos
│   ├── backgrounds/           # Background images
│   └── ui/                    # UI element images
├── css/                       # CSS frameworks
│   ├── bootstrap/            # Bootstrap framework
│   ├── tailwind/             # Tailwind CSS
│   └── custom/                # Custom stylesheets
├── js/                        # JavaScript libraries
│   ├── jquery/               # jQuery library
│   ├── chart.js/             # Chart.js library
│   └── custom/                # Custom JavaScript
├── templates/                 # Document templates
│   ├── reports/               # Report templates
│   ├── invoices/              # Invoice templates
│   └── contracts/             # Contract templates
└── README.md                  # This file
```

## Asset Types

### Fonts
- **Web fonts**: WOFF, WOFF2, TTF, EOT formats
- **Font families**: Roboto, Open Sans, custom fonts
- **Font weights**: Regular, bold, light, medium
- **Character sets**: Latin, extended Latin, Unicode

### Icons
- **Icon libraries**: Material Icons, Font Awesome, Feather
- **Formats**: SVG, PNG, ICO, WebP
- **Sizes**: 16px, 24px, 32px, 48px, 64px
- **Styles**: Outlined, filled, rounded, sharp

### Images
- **Logos**: Company logos, product logos, brand assets
- **Backgrounds**: Hero images, pattern backgrounds
- **UI elements**: Buttons, cards, navigation elements
- **Formats**: JPEG, PNG, SVG, WebP, AVIF

### CSS Frameworks
- **Bootstrap**: Responsive CSS framework
- **Tailwind CSS**: Utility-first CSS framework
- **Material Design**: Google's design system
- **Custom CSS**: Application-specific styles

### JavaScript Libraries
- **jQuery**: DOM manipulation and AJAX
- **Chart.js**: Data visualization library
- **Moment.js**: Date and time manipulation
- **Lodash**: Utility functions library

## Asset Management

### File Organization
```javascript
// Asset loading configuration
const assetConfig = {
  fonts: {
    'Roboto': ['fonts/roboto/Roboto-Regular.woff2', 'fonts/roboto/Roboto-Bold.woff2'],
    'Open Sans': ['fonts/open-sans/OpenSans-Regular.woff2']
  },
  icons: {
    'Material Icons': 'icons/material-icons/material-icons.woff2',
    'Font Awesome': 'icons/font-awesome/fontawesome.woff2'
  },
  images: {
    'Logo': 'images/logos/company-logo.svg',
    'Background': 'images/backgrounds/hero-bg.jpg'
  }
};
```

### Asset Optimization
```javascript
// Image optimization
const optimizeImage = async (imagePath) => {
  const sharp = require('sharp');
  
  await sharp(imagePath)
    .resize(800, 600, { fit: 'inside' })
    .jpeg({ quality: 80 })
    .webp({ quality: 80 })
    .toFile(imagePath.replace('.jpg', '.webp'));
};

// Font optimization
const optimizeFonts = async () => {
  // Subset fonts to include only used characters
  // Compress font files
  // Generate multiple formats (WOFF, WOFF2)
};
```

### Asset Versioning
```javascript
// Asset versioning for cache busting
const assetVersion = '1.0.0';
const getAssetUrl = (path) => {
  return `/assets/${path}?v=${assetVersion}`;
};

// Usage
const logoUrl = getAssetUrl('images/logos/company-logo.svg');
const fontUrl = getAssetUrl('fonts/roboto/Roboto-Regular.woff2');
```

## Performance Optimization

### Font Loading
```css
/* Font loading optimization */
@font-face {
  font-family: 'Roboto';
  src: url('fonts/roboto/Roboto-Regular.woff2') format('woff2'),
       url('fonts/roboto/Roboto-Regular.woff') format('woff');
  font-display: swap; /* Improve loading performance */
  font-weight: 400;
  font-style: normal;
}
```

### Image Optimization
```javascript
// Responsive images with different sizes
const responsiveImages = {
  small: 'images/hero-bg-400w.jpg',
  medium: 'images/hero-bg-800w.jpg',
  large: 'images/hero-bg-1200w.jpg',
  xlarge: 'images/hero-bg-1600w.jpg'
};

// Lazy loading for images
const lazyLoadImages = () => {
  const images = document.querySelectorAll('img[data-src]');
  const imageObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.remove('lazy');
        imageObserver.unobserve(img);
      }
    });
  });
  
  images.forEach(img => imageObserver.observe(img));
};
```

### CSS Optimization
```css
/* Critical CSS for above-the-fold content */
.critical-css {
  /* Inline critical styles */
}

/* Non-critical CSS loaded asynchronously */
<link rel="preload" href="assets/css/main.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
```

## Asset Delivery

### CDN Integration
```javascript
// CDN configuration
const cdnConfig = {
  baseUrl: 'https://cdn.example.com/assets',
  regions: ['us-east-1', 'eu-west-1', 'ap-southeast-1'],
  cache: {
    images: '1y',
    fonts: '1y',
    css: '1M',
    js: '1M'
  }
};

// Asset URL generation
const getCDNAssetUrl = (path) => {
  return `${cdnConfig.baseUrl}/${path}`;
};
```

### Compression
```javascript
// Asset compression
const compressAssets = async () => {
  const gzip = require('gzip');
  const brotli = require('brotli');
  
  // Compress CSS and JS files
  await gzip.compress('assets/css/main.css');
  await brotli.compress('assets/js/main.js');
};
```

## Security Considerations

### Asset Validation
```javascript
// Validate asset files
const validateAsset = (filePath) => {
  const allowedExtensions = ['.css', '.js', '.woff', '.woff2', '.svg', '.png', '.jpg'];
  const ext = path.extname(filePath).toLowerCase();
  
  if (!allowedExtensions.includes(ext)) {
    throw new Error('Invalid asset file type');
  }
  
  // Check file size limits
  const stats = fs.statSync(filePath);
  if (stats.size > 5 * 1024 * 1024) { // 5MB limit
    throw new Error('Asset file too large');
  }
};
```

### Content Security Policy
```javascript
// CSP headers for assets
const cspConfig = {
  'default-src': "'self'",
  'style-src': "'self' 'unsafe-inline' https://fonts.googleapis.com",
  'font-src': "'self' https://fonts.gstatic.com",
  'img-src': "'self' data: https:",
  'script-src': "'self' 'unsafe-inline'"
};
```

## Asset Monitoring

### Performance Metrics
```javascript
// Asset loading performance
const monitorAssetPerformance = () => {
  const observer = new PerformanceObserver((list) => {
    list.getEntries().forEach(entry => {
      if (entry.entryType === 'resource') {
        console.log(`Asset loaded: ${entry.name}, Duration: ${entry.duration}ms`);
      }
    });
  });
  
  observer.observe({ entryTypes: ['resource'] });
};
```

### Error Tracking
```javascript
// Track asset loading errors
window.addEventListener('error', (event) => {
  if (event.target.tagName === 'IMG' || event.target.tagName === 'LINK') {
    console.error('Asset loading error:', event.target.src || event.target.href);
    // Send error to monitoring service
  }
});
```

## Best Practices

### File Organization
1. **Group related assets** in subdirectories
2. **Use descriptive filenames** for easy identification
3. **Maintain consistent naming** conventions
4. **Version control** for asset changes
5. **Document asset usage** and dependencies

### Performance Optimization
1. **Optimize images** for web delivery
2. **Use appropriate formats** for different asset types
3. **Implement lazy loading** for non-critical assets
4. **Use CDN** for global asset delivery
5. **Monitor asset performance** and loading times

### Security Measures
1. **Validate all assets** before serving
2. **Implement proper caching** headers
3. **Use HTTPS** for all asset delivery
4. **Scan assets** for malicious content
5. **Implement CSP** for asset security

### Maintenance
1. **Regular cleanup** of unused assets
2. **Update dependencies** and libraries
3. **Monitor asset usage** and performance
4. **Backup important assets** regularly
5. **Document asset changes** and updates
