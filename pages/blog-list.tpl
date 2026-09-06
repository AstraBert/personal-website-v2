<!doctype html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Clelia's Blog</title>
<link rel="icon" type="image/x-icon" href="../static/favicon.ico">
<link href="../static/blog-list-styles.css" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@500;600;700;800&family=Nunito:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <nav>
            <a href="../">Home</a>
            <a href="https://github.com/AstraBert">GitHub</a>
        </nav>
    </header>
    <section class="title">
        <h1>Clelia's Blog</h1>
        <h3>Thoughts and ideas, sometimes random, in one place</h3>
    </section>
    <section class="list">
        <!-- Entry as defined in blog-list-entry.tpl  -->
        {{ entries }}
    </section>
    <footer class="blog-footer">
        <p>&copy; 2026 Clelia Astra Bertelli</p>
        <div class="footer-links">
        <a href="./">Blog</a>
        <a href="https://github.com/AstraBert" target="_blank" rel="noopener">GitHub</a>
        <a href="https://www.linkedin.com/in/clelia-astra-bertelli-583904297/" target="_blank" rel="noopener">LinkedIn</a>
        </div>
    </footer>
</body>
</html>
