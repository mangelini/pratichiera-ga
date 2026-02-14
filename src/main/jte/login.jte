@param String error = null
@param String logout = null

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pratichiera Gruppi Acquisto</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/js/tailwind_config.js"></script>

</head>
<body>
<main class="flex flex-col justify-center min-h-screen p-4 bg-gray-50">
    <article class="w-full max-w-md mx-auto bg-white p-8 rounded-lg shadow-md">
        <header class="text-center mb-6">
            <img
                    src="https://cdn.shopify.com/s/files/1/0962/4780/8325/files/logo_pratichiera_mail.png?v=1761201467"
                    style="max-height: 100px; width: auto;"
                    class="mx-auto block mb-4"
            >
            <hgroup>
                <p class="text-center text-gray-600 text-lg">Gruppi Acquisto</p>
            </hgroup>
        </header>

        @if(error != null)
            <div role="alert" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4">
                ${error}
            </div>
        @endif

        @if(logout != null)
            <div role="alert" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4">
                Sei stato disconnesso.
            </div>
        @endif

        <form action="/login" method="post" class="space-y-4">
            <label for="username" class="block">
                <span class="text-gray-700">Username</span>
                <input type="text" id="username" name="username" placeholder="Username" required
                       class="mt-1 block w-full px-3 py-2 bg-white border rounded-md text-sm shadow-sm placeholder-gray-400"
                >
            </label>

            <label for="password" class="block">
                <span class="text-gray-700">Password</span>
                <input type="password" id="password" name="password" placeholder="Password" required
                       class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400"
                >
            </label>

            <button type="submit"
                    class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary-hover focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
            >
                Login
            </button>
        </form>
    </article>
</main>
</body>
</html>