@import com.pratichiera.pratichieraga.model.UserEntity
@import com.pratichiera.pratichieraga.model.PriceListEntity
@import java.util.List

@param List<UserEntity> users
@param List<PriceListEntity> priceLists

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Pannello Amministratore</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/js/tailwind_config.js"></script>
</head>
<body class="bg-gray-50">
<main class="container mx-auto px-4 py-6">
    <nav class="flex flex-col md:flex-row justify-between items-center mb-8 bg-white p-4 rounded-lg shadow">
        <div class="mb-4 md:mb-0">
            <strong>Amministrazione Caseificio Pratichiera</strong>
        </div>
        <ul class="flex gap-4 items-center">
            <li><a href="/admin/orders" role="button" class="text-primary hover:text-primary-hover font-semibold">Vedi Ordini</a></li>
            <li>
                <form action="/logout" method="post" class="inline">
                    <button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center">Esci</button>
                </form>
            </li>
        </ul>
    </nav>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <article class="bg-white p-6 rounded-lg shadow">
            <header class="font-bold text-xl mb-4 border-b pb-2">Nuovo Gruppo Acquisto</header>
            <form action="/admin/users" method="post" class="space-y-4">
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
                <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary-hover focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">Crea Utente</button>
            </form>
        </article>

        <article class="bg-white p-6 rounded-lg shadow">
            <header class="font-bold text-xl mb-4 border-b pb-2">Nuovo Listino Mensile</header>
            <form action="/admin/pricelists" method="post" class="space-y-4">
                <label class="block">
                    <span class="text-gray-700">Nome Listino</span>
                    <input type="text" name="name" placeholder="Es. Febbraio 2026" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
                <label class="block">
                    <span class="text-gray-700">Mese di Riferimento</span>
                    <input type="month" name="month" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
                <button type="submit" class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary-hover focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">
                    Crea e Modifica Listino
                </button>
            </form>
        </article>
    </div>

    <hr class="my-8 border-gray-300">

    <h3 class="text-2xl font-bold mb-4">Listini Presenti</h3>
    <figure class="overflow-x-auto bg-white rounded-lg shadow">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nome</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Mese</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Gruppi Assegnati</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Azioni</th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            @for(PriceListEntity pl : priceLists)
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${pl.getId()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${pl.getName()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${String.valueOf(pl.getReferenceMonth())}</td>
                    <td class="px-6 py-4 text-sm text-gray-500">
                        @if(pl.getUsers().isEmpty())
                            <span class="italic text-gray-400">Nessuno</span>
                        @else
                            ${pl.getUsers().stream().map(u -> u.getUsername()).collect(java.util.stream.Collectors.joining(", "))}
                        @endif
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <div class="flex items-center gap-2">
                            <a href="/admin/pricelists/${pl.getId()}" role="button" class="text-indigo-600 hover:text-indigo-900 border border-indigo-600 rounded px-2 py-1 text-xs">Modifica</a>
                            <form action="/admin/pricelists/${pl.getId()}/delete" method="post" onsubmit="return confirm('Sei sicuro di voler eliminare questo listino?');" class="inline">
                                <button type="submit" class="text-red-600 hover:text-red-900 border border-red-600 rounded px-2 py-1 text-xs bg-white">Elimina</button>
                            </form>
                        </div>
                    </td>
                </tr>
            @endfor
            </tbody>
        </table>
    </figure>
</main>
</body>
</html>