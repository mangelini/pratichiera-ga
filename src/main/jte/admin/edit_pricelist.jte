@import com.pratichiera.pratichieraga.model.PriceListEntity
@import com.pratichiera.pratichieraga.model.PriceListItemEntity
@import com.pratichiera.pratichieraga.model.UserEntity

@param PriceListEntity priceList
@param Iterable<UserEntity> allUsers

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <title>Modifica Listino</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/js/tailwind_config.js"></script>
</head>
<body class="bg-gray-50">
<main class="container mx-auto px-4 py-6">
    <header class="flex flex-col md:flex-row justify-between items-center mb-8 bg-white p-4 rounded-lg shadow">
        <hgroup class="mb-4 md:mb-0">
            <h2 class="text-2xl font-bold text-gray-800">Modifica Listino: <span class="text-primary">${priceList.getName()}</span></h2>
            <p class="text-gray-600">Mese: <span class="font-semibold">${String.valueOf(priceList.getReferenceMonth())}</span></p>
        </hgroup>
        <div>
            <a href="/admin" role="button" class="text-gray-600 hover:text-gray-900 border border-gray-300 rounded px-4 py-2 hover:bg-gray-100 transition">Torna Indietro</a>
        </div>
    </header>

    <article class="bg-white p-6 rounded-lg shadow mb-8">
        <header class="font-bold text-xl mb-4 border-b pb-2">Gruppi Acquisto Assegnati</header>

        @if(priceList.getUsers().isEmpty())
            <p class="text-gray-500 italic mb-4">Nessun gruppo assegnato.</p>
        @else
            <div class="flex flex-wrap gap-2 mb-4">
                @for(UserEntity u : priceList.getUsers())
                    <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-sm font-medium bg-primary text-white">
                        ${u.getUsername()}
                        <form action="/admin/pricelists/${priceList.getId()}/users/${u.getId()}/remove" method="post" class="inline-flex">
                            <button type="submit" title="Rimuovi" class="text-white hover:text-gray-200 focus:outline-none">✕</button>
                        </form>
                    </span>
                @endfor
            </div>
        @endif

        <form action="/admin/pricelists/${priceList.getId()}/users/add" method="post" class="flex flex-col sm:flex-row gap-4 items-end">
             <div class="w-full sm:w-auto flex-grow relative">
                <select name="userId" id="userSelect" required class="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400 h-10">
                    <option value="" disabled selected>Cerca gruppo...</option>
                    @for(UserEntity u : allUsers)
                        @if(!u.getIsAdmin() && !priceList.getUsers().contains(u))
                            <option value="${u.getId()}">${u.getUsername()}</option>
                        @endif
                    @endfor
                </select>
            </div>
            <button type="submit" class="w-full sm:w-auto bg-green-600 text-white font-bold py-2 px-4 rounded hover:bg-green-700 transition duration-150 h-10 flex items-center justify-center">+ Aggiungi</button>
        </form>
    </article>

    <article class="bg-white p-6 rounded-lg shadow mb-8">
        <header class="font-bold text-xl mb-4 border-b pb-2">Aggiungi Prodotto</header>
        <form action="/admin/pricelists/${priceList.getId()}/items" method="post" class="space-y-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class="block">
                    <span class="text-gray-700">Nome Prodotto</span>
                    <input type="text" name="productName" placeholder="Es. Parmigiano 30 mesi" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
                <label class="block">
                    <span class="text-gray-700">Confezione</span>
                    <input type="text" name="packaging" placeholder="Es. Punta 1kg" class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class="block">
                    <span class="text-gray-700">Prezzo al Kg (€)</span>
                    <input type="number" step="0.01" name="price" required class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
                <label class="block">
                    <span class="text-gray-700">Note</span>
                    <input type="text" name="notes" class="mt-1 block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400">
                </label>
            </div>
            <button type="submit" class="w-full md:w-auto bg-primary text-white font-medium text-small py-2 px-6 rounded hover:bg-primary-hover focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary">Aggiungi Riga</button>
        </form>
    </article>

    <h3 class="text-2xl font-bold mb-4">Prodotti in Listino</h3>
    <figure class="overflow-x-auto bg-white rounded-lg shadow">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prodotto</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Confezione</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prezzo/Kg</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Note</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"></th>
            </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
            @for(PriceListItemEntity item : priceList.getItems())
                <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${item.getProductName()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${item.getPackaging()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">€ ${item.getPricePerKg()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${item.getNotes()}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <form action="/admin/items/${item.getId()}/delete" method="post" style="margin:0;" class="inline">
                            <button type="submit" class="text-red-600 hover:text-red-900 border border-red-600 rounded px-2 py-1 text-xs bg-white hover:bg-red-50 transition">Rimuovi</button>
                        </form>
                    </td>
                </tr>
            @endfor
            </tbody>
        </table>
    </figure>
</main>

<script>
    // Simple client-side filtering for the user dropdown
    const select = document.getElementById('userSelect');
    if (select && select.options.length > 10) {
        const wrapper = select.parentElement;
        const searchInput = document.createElement('input');
        searchInput.type = 'search';
        searchInput.placeholder = 'Filtra gruppi...';
        // Tailwind classes for the input
        searchInput.className = 'block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring focus:ring-primary focus:ring-opacity-50 text-sm mb-2 p-2 border';
        wrapper.insertBefore(searchInput, select);

        const allOptions = Array.from(select.options).slice(1); // skip the placeholder

        searchInput.addEventListener('input', () => {
            const query = searchInput.value.toLowerCase();
            select.innerHTML = '';
            const placeholder = document.createElement('option');
            placeholder.value = '';
            placeholder.disabled = true;
            placeholder.selected = true;
            placeholder.textContent = 'Cerca gruppo...';
            select.appendChild(placeholder);

            allOptions.forEach(opt => {
                if (opt.textContent.toLowerCase().includes(query)) {
                    select.appendChild(opt.cloneNode(true));
                }
            });
        });
    }
</script>
</body>
</html>