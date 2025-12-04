import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/ui/components/app_text_field.dart';
import '../../../../core/ui/components/loading_widget.dart';
import '../../../../core/ui/components/error_widget.dart';
import '../../../../core/ui/components/error_message_mapper.dart';
import '../../../../core/ui/components/empty_state_widget.dart';
import '../../../../di/providers.dart';
import '../../domain/entities/favorite_city.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
    // Debounce timer for search
    Timer? _debounce;
  final _controller = TextEditingController();
  String? _selectedRegion;
  
  final Map<String, String> _regions = {
    'All': '',
    'Africa': 'AF',
    'Asia': 'AS',
    'Europe': 'EU',
    'North America': 'NA',
    'South America': 'SA',
    'Oceania': 'OC',
  };

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
    void _onSearchChanged(String value) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        ref.read(searchVmProvider.notifier).search(value);
      });
    }
  
  List<dynamic> _filterByRegion(List<dynamic> results) {
    if (_selectedRegion == null || _selectedRegion == 'All') {
      return results;
    }
    
    // Filter by country codes based on region
    final regionCountries = _getCountriesForRegion(_selectedRegion!);
    return results.where((city) => regionCountries.contains(city.country)).toList();
  }
  
  Set<String> _getCountriesForRegion(String region) {
    switch (region) {
      case 'Africa':
        return {'DZ', 'AO', 'BJ', 'BW', 'BF', 'BI', 'CM', 'CV', 'CF', 'TD', 'KM', 'CG', 'CD', 'CI', 'DJ', 'EG', 'GQ', 'ER', 'ET', 'GA', 'GM', 'GH', 'GN', 'GW', 'KE', 'LS', 'LR', 'LY', 'MG', 'MW', 'ML', 'MR', 'MU', 'YT', 'MA', 'MZ', 'NA', 'NE', 'NG', 'RE', 'RW', 'SH', 'ST', 'SN', 'SC', 'SL', 'SO', 'ZA', 'SS', 'SD', 'SZ', 'TZ', 'TG', 'TN', 'UG', 'ZM', 'ZW'};
      case 'Asia':
        return {'AF', 'AM', 'AZ', 'BH', 'BD', 'BT', 'BN', 'KH', 'CN', 'GE', 'HK', 'IN', 'ID', 'IR', 'IQ', 'IL', 'JP', 'JO', 'KZ', 'KW', 'KG', 'LA', 'LB', 'MO', 'MY', 'MV', 'MN', 'MM', 'NP', 'KP', 'OM', 'PK', 'PS', 'PH', 'QA', 'SA', 'SG', 'KR', 'LK', 'SY', 'TW', 'TJ', 'TH', 'TR', 'TM', 'AE', 'UZ', 'VN', 'YE'};
      case 'Europe':
        return {'AX', 'AL', 'AD', 'AT', 'BY', 'BE', 'BA', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FO', 'FI', 'FR', 'DE', 'GI', 'GR', 'GG', 'HU', 'IS', 'IE', 'IM', 'IT', 'JE', 'LV', 'LI', 'LT', 'LU', 'MK', 'MT', 'MD', 'MC', 'ME', 'NL', 'NO', 'PL', 'PT', 'RO', 'RU', 'SM', 'RS', 'SK', 'SI', 'ES', 'SE', 'CH', 'UA', 'GB', 'VA'};
      case 'North America':
        return {'AI', 'AG', 'AW', 'BS', 'BB', 'BZ', 'BM', 'BQ', 'CA', 'KY', 'CR', 'CU', 'CW', 'DM', 'DO', 'SV', 'GL', 'GD', 'GP', 'GT', 'HT', 'HN', 'JM', 'MQ', 'MX', 'MS', 'NI', 'PA', 'PM', 'PR', 'KN', 'LC', 'VC', 'SX', 'TT', 'TC', 'US', 'VG', 'VI'};
      case 'South America':
        return {'AR', 'BO', 'BR', 'CL', 'CO', 'EC', 'FK', 'GF', 'GY', 'PY', 'PE', 'SR', 'UY', 'VE'};
      case 'Oceania':
        return {'AS', 'AU', 'CK', 'FJ', 'PF', 'GU', 'KI', 'MH', 'FM', 'NR', 'NC', 'NZ', 'NU', 'NF', 'MP', 'PW', 'PG', 'PN', 'WS', 'SB', 'TK', 'TO', 'TV', 'VU', 'WF'};
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchVmProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search City')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AppTextField(
              controller: _controller,
              hint: 'Enter city name',
              onChanged: _onSearchChanged,
              onSubmitted: () => ref.read(searchVmProvider.notifier).search(_controller.text),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.filter_list, size: 20),
                const SizedBox(width: 8),
                const Text('Filter by Region:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedRegion,
                    hint: const Text('All Regions'),
                    items: _regions.keys.map((String region) {
                      return DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRegion = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.when(
                data: (results) {
                  final filteredResults = _filterByRegion(results);
                  if (filteredResults.isEmpty && _controller.text.isNotEmpty) {
                    return EmptyStateWidget(
                      message: _selectedRegion != null && _selectedRegion != 'All'
                          ? 'No cities found in $_selectedRegion'
                          : 'No cities found',
                      icon: Icons.search_off,
                    );
                  }
                  if (results.isEmpty) {
                    return const EmptyStateWidget(
                      message: 'Search for a city',
                      icon: Icons.search,
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredResults.length,
                    itemBuilder: (context, i) {
                      final city = filteredResults[i];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text(city.name),
                          subtitle: Text('${city.country} • Lat: ${city.lat.toStringAsFixed(2)}, Lon: ${city.lon.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () {
                                  final favorite = FavoriteCity(
                                    id: '${city.lat}_${city.lon}',
                                    name: city.name,
                                    lat: city.lat,
                                    lon: city.lon,
                                  );
                                  ref.read(favoritesVmProvider.notifier).add(favorite);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${city.name} added to favorites')),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  ref.read(homeVmProvider.notifier).load(city.lat, city.lon);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const LoadingWidget(),
                error: (e, _) => AppErrorWidget(message: mapErrorToMessage(e)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
