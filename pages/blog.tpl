<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{{ title }}</title>
<link rel="icon" type="image/x-icon" href="/static/favicon.ico">
<link href="/static/blog-styles.css" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@500;600;700;800&family=Nunito:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <nav>
            <a href="/">Home</a>
            <a href="https://github.com/AstraBert">GitHub</a>
        </nav>
    </header>
    <section class="meta">
        <span class="author">{{ author }}</span>
        <span class="date">{{ publishDate }}</span>
        <span class="category">{{ category }}</span>
    </section>
    <section class="title">
        <h1>{{ title }}</h1>
        <h3>{{ excerpt }}</h3>
    </section>
    <section class="content">
        {{ content }}
    </section>
    <footer class="blog-footer">
        <p>&copy; 2026 Clelia Astra Bertelli</p>
        <div class="footer-links">
        <a href="/blog">Blog</a>
        <a href="https://github.com/AstraBert" target="_blank" rel="noopener">GitHub</a>
        <a href="https://www.linkedin.com/in/clelia-astra-bertelli-583904297/" target="_blank" rel="noopener">LinkedIn</a>
        </div>
    </footer>
</body>
</html>
