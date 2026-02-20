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
                        <td class="px-6 py-4 text-sm text-gray-500 relative">
                            <details class="group">
                                <summary class="cursor-pointer inline-flex items-center gap-2 px-3 py-1.5 bg-primary/10 hover:bg-primary/20 text-primary rounded-full text-sm font-medium transition-colors">
                                    <svg class="w-4 h-4 transition-transform group-open:rotate-180" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                                    </svg>
                                    <span>${order.getItems().size()} prodott${order.getItems().size() == 1 ? "o" : "i"}</span>
                                </summary>
                                <div class="mt-4 bg-white rounded-lg border border-gray-200 overflow-hidden">
                                    <div class="max-h-80 overflow-y-auto">
                                        <table class="min-w-full">
                                            <thead class="bg-gray-50 sticky top-0">
                                                <tr>
                                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Prodotto</th>
                                                    <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Conf.</th>
                                                    <th class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">Prezzo/Kg</th>
                                                    <th class="px-6 py-4 text-center text-xs font-semibold text-gray-600 uppercase tracking-wider">Qtà</th>
                                                    <th class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">Totale</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100">
                                                @for(OrderItemEntity item : order.getItems())
                                                    <tr class="hover:bg-gray-50 transition-colors">
                                                        <td class="px-6 py-4 text-base text-gray-900 font-medium">${item.getProductName()}</td>
                                                        <td class="px-6 py-4 text-base text-gray-500">${item.getPackaging()}</td>
                                                        <td class="px-6 py-4 text-base text-gray-500 text-right">€ ${item.getPricePerKg()}</td>
                                                        <td class="px-6 py-4 text-base text-center">
                                                            <span class="inline-flex items-center justify-center min-w-10 h-10 px-3 bg-primary/10 text-primary font-bold rounded-full">${item.getQuantity()}</span>
                                                        </td>
                                                        <td class="px-6 py-4 text-base text-gray-900 font-semibold text-right">€ ${item.getTotalPrice()}</td>
                                                    </tr>
                                                @endfor
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="px-6 py-4 bg-gray-50 border-t border-gray-200 flex justify-between items-center">
                                        <span class="text-sm text-gray-500">${order.getItems().size()} prodott${order.getItems().size() == 1 ? "o" : "i"}</span>
                                        <span class="text-base font-semibold text-gray-900">Totale: € ${totalPrice}</span>
                                    </div>
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
