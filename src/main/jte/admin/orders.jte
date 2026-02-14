@import com.pratichiera.pratichieraga.model.OrderEntity
@import com.pratichiera.pratichieraga.model.OrderItemEntity
@import java.util.List
@import java.time.format.DateTimeFormatter
@import java.time.ZoneId

@param List<OrderEntity> orders

<!DOCTYPE html>
<html lang="it" data-theme="light">
<head>
    <meta charset="utf-8">
    <title>Ordini - Pannello Amministratore</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="/js/tailwind_config.js"></script>
    <style>
        details > summary {
            list-style: none;
        }
        details > summary::-webkit-details-marker {
            display: none;
        }
    </style>
</head>
<body class="bg-gray-50">
<main class="container mx-auto px-4 py-6">
    <nav class="flex flex-col md:flex-row justify-between items-center mb-8 bg-white p-4 rounded-lg shadow">
        <ul class="mb-4 md:mb-0">
            <li><strong><a href="/admin" class="text-gray-600 hover:text-primary font-bold">Pannello Amministratore</a></strong></li>
        </ul>
        <ul class="mb-4 md:mb-0">
            <li><h1 class="text-2xl font-bold text-gray-800">Ordini Ricevuti</h1></li>
        </ul>
        <ul class="flex items-center justify-center gap-4">
            <li><a href="/admin" role="button" class="text-gray-600 hover:text-gray-900 border border-gray-300 rounded px-4 py-2 hover:bg-gray-100 transition">Torna Indietro</a></li>
            <li><form action="/logout" method="post" class="inline"><button class="bg-gray-200 hover:bg-gray-300 text-gray-800 font-bold py-2 px-4 rounded">Esci</button></form></li>
        </ul>
    </nav>

    <hr class="my-8 border-gray-300">

    @if(orders.isEmpty())

        <article class="bg-white p-6 rounded-lg shadow text-center">
            <h3 class="text-xl font-bold mb-2">Nessun ordine presente</h3>
            <p class="text-gray-600">Non sono stati ancora ricevuti ordini.</p>
        </article>
    @else
        <div class="overflow-x-auto bg-white rounded-lg shadow">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Data</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Utente</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Totale Stimato</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Dettagli</th>
                </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                @for(OrderEntity order : orders)
                   !{var totalPrice = java.math.BigDecimal.ZERO;}
                   @for(OrderItemEntity item : order.getItems())
                        !{totalPrice = totalPrice.add(item.getTotalPrice());}
                   @endfor

                    <tr class="hover:bg-gray-50">
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">#${order.getId()}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">${DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZoneId.systemDefault()).format(order.getCreatedDate())}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">${order.getUser().getUsername()}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">€ ${totalPrice}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            <details class="group">
                                <summary class="cursor-pointer text-primary hover:text-primary-hover font-medium flex items-center">
                                    <span>Vedi Prodotti (${order.getItems().size()})</span>
                                    <svg class="w-4 h-4 ml-2 transition-transform group-open:rotate-180" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                </summary>
                                <div class="mt-4 border-l-2 border-gray-100 pl-4 bg-gray-50 rounded p-4">
                                    <table class="min-w-full divide-y divide-gray-200">
                                        <thead>
                                            <tr>
                                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Prodotto</th>
                                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Conf.</th>
                                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Prezzo/Kg</th>
                                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Qtà</th>
                                                <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Totale</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-gray-200">
                                            @for(OrderItemEntity item : order.getItems())
                                                <tr>
                                                    <td class="px-4 py-2 text-sm text-gray-900">${item.getProductName()}</td>
                                                    <td class="px-4 py-2 text-sm text-gray-500">${item.getPackaging()}</td>
                                                    <td class="px-4 py-2 text-sm text-gray-500">€ ${item.getPricePerKg()}</td>
                                                    <td class="px-4 py-2 text-sm text-gray-900 font-bold">${item.getQuantity()}</td>
                                                    <td class="px-4 py-2 text-sm text-gray-500">€ ${item.getTotalPrice()}</td>
                                                </tr>
                                            @endfor
                                        </tbody>
                                    </table>
                                </div>
                            </details>
                        </td>
                    </tr>
                @endfor
                </tbody>
            </table>
        </div>
    @endif
</main>
</body>
</html>
