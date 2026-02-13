@param String error = null
@param String logout = null

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pratichiera Gruppi Acquisto</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <link rel="stylesheet" href="/css/custom.css">
    <style>
        body > main {
            display: flex;
            flex-direction: column;
            justify-content: center;
            min-height: 100vh;
            padding: 1rem;
        }
        article {
            width: 100%;
            max-width: 480px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
<main>
    <article>
        <header style="text-align: center;">
            <img
                    src="https://cdn.shopify.com/s/files/1/0962/4780/8325/files/logo_pratichiera_mail.png?v=1761201467"
                    style="max-height: 100px; width: auto; margin: 0 auto 1rem; display: block;"
            >
            <hgroup>
                <p style="text-align: center;">Gruppi Acquisto</p>
            </hgroup>
        </header>

        @if(error != null)
            <div role="alert" style="background-color: #ffe6e6; color: #d32f2f; padding: 10px; border-radius: 5px; margin-bottom: 1rem;">
                ${error}
            </div>
        @endif

        @if(logout != null)
            <div role="alert" style="background-color: #e8f5e9; color: #2e7d32; padding: 10px; border-radius: 5px; margin-bottom: 1rem;">
                Sei stato disconnesso.
            </div>
        @endif

        <form action="/login" method="post">
            <label for="username">
                Username
                <input type="text" id="username" name="username" placeholder="Username" required>
            </label>

            <label for="password">
                Password
                <input type="password" id="password" name="password" placeholder="Password" required>
            </label>

            <button type="submit">Login</button>
        </form>
    </article>
</main>
</body>
</html>