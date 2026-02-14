@import com.pratichiera.pratichieraga.model.PriceListEntity
@import com.pratichiera.pratichieraga.model.PriceListItemEntity
@import com.pratichiera.pratichieraga.model.UserEntity

@param PriceListEntity priceList
@param UserEntity user
@param Boolean success = false

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Ordine - ${user.getUsername()}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/js/tailwind_config.js"></script>
</head>
<body class="bg-gray-50">
<header class="bg-white shadow">
    <nav class="container mx-auto px-4 py-4 flex flex-col md:flex-row justify-between items-center">
        <img
                src="https://cdn.shopify.com/s/files/1/0962/4780/8325/files/logo_pratichiera_mail.png?v=1761201467"
                style="max-height: 20px; width: auto;"
                class="mx-2 block"
        >
        <div class="font-bold text-xl mb-4 md:mb-0 text-gray-800">Pratichiera Gruppi Acquisto</div>
        <ul class="flex gap-4 items-center">
            <li class="text-gray-600">Benvenuto, <span class="font-semibold text-gray-800">${user.getUsername()}</span></li>
            <li><form action="/logout" method="post" class="inline"><button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded inline-flex items-center text-sm">Esci</button></form></li>
        </ul>
    </nav>
</header>

<main class="container mx-auto px-4 py-8">
    @if(success)
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6" role="alert">
            <strong class="font-bold">Ottimo!</strong>
            <span class="block sm:inline">Ordine salvato con successo!</span>
        </div>
    @endif

    @if(priceList == null)
        <article class="bg-white p-8 rounded-lg shadow text-center">
            <h3 class="text-xl font-bold mb-2 text-gray-800">Nessun listino attivo</h3>
            <p class="text-gray-600">Non c'è ancora un listino prezzi disponibile per questo mese. Attendi la comunicazione dell'amministratore.</p>
        </article>
    @else
        <div class="mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Listino: <span class="text-primary">${String.valueOf(priceList.getName())}</span></h2>
            <p class="text-gray-600">Compila le quantità desiderate e clicca su "Salva Ordine".</p>
        </div>

        <form action="/orders/submit" method="post" id="orderForm">
            <div class="overflow-x-auto bg-white rounded-lg shadow mb-8">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prodotto</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Confezione</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Prezzo/Kg</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Note</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider" style="width: 140px;">Quantità</th>
                    </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                    @for(PriceListItemEntity item : priceList.getItems())
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-bold text-gray-900">${item.getProductName()}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${item.getPackaging()}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">€ ${item.getPricePerKg()}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 italic"><small>${item.getNotes()}</small></td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                <input type="number"
                                       name="qty_${item.getId()}"
                                       value="${item.getQuantity()}"
                                       min="0" step="1"
                                       class="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md text-sm shadow-sm placeholder-gray-400"
                                >
                            </td>
                        </tr>
                    @endfor
                    </tbody>
                </table>
            </div>
            <footer class="sticky bottom-0 p-4 border-t mt-4 flex flex-col justify-center">
                <div class="bg-white p-6 rounded-lg shadow mb-6">
                    <h3 class="text-lg font-semibold text-gray-800 mb-4">I tuoi dati</h3>
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                        <div>
                            <label for="fullName" class="block text-sm font-medium text-gray-700 mb-1">Nome Completo / Ragione Sociale *</label>
                            <input type="text" id="fullName" name="fullName" required
                                   class="align-middle block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm p-2 border">
                        </div>
                        <div>
                            <label for="phoneNumber" class="block text-sm font-medium text-gray-700 mb-1">Telefono *</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" required
                                   class="align-middle block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm p-2 border">
                        </div>
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email *</label>
                            <input type="email" id="email" name="email" required
                                   class="align-middle block w-full rounded-md border-gray-300 shadow-sm focus:border-primary focus:ring-primary sm:text-sm p-2 border">
                        </div>
                    </div>
                </div>
                <button type="submit" id="submitOrderBtn" disabled
                        class="self-end py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-primary hover:bg-primary-hover focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50 disabled:cursor-not-allowed">
                    Invia Ordine
                </button>
            </footer>
        </form>
    @endif
</main>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('orderForm');
        const submitBtn = document.getElementById('submitOrderBtn');
        const inputs = [
            document.getElementById('fullName'),
            document.getElementById('phoneNumber'),
            document.getElementById('email')
        ];

        function checkInputs() {
            const allFilled = inputs.every(input => input.value.trim() !== '');
            submitBtn.disabled = !allFilled;
        }

        inputs.forEach(input => {
            input.addEventListener('input', checkInputs);
        });

        // Check initially in case of auto-fill
        checkInputs();
    });
</script>
</body>
</html>