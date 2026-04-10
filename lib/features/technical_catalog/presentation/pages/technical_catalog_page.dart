import 'package:crm_tuberias_valvulas_mobile/core/design_system/card_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/crm_page_shell.dart';
import '../../domain/entities/catalog_product.dart';
import '../../domain/entities/technical_datasheet.dart';
import '../providers/technical_catalog_providers.dart';

class TechnicalCatalogPage extends ConsumerStatefulWidget {
  const TechnicalCatalogPage({super.key});

  @override
  ConsumerState<TechnicalCatalogPage> createState() =>
      _TechnicalCatalogPageState();
}

class _TechnicalCatalogPageState extends ConsumerState<TechnicalCatalogPage> {
  String? _selectedProductType;
  String? _selectedMaterial;
  String? _selectedStandard;
  String? _selectedValveType;

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(
      technicalCatalogProductsProvider(
        productType: _selectedProductType,
        material: _selectedMaterial,
        standard: _selectedStandard,
        valveType: _selectedValveType,
      ),
    );
    final datasheetsState = ref.watch(
      technicalCatalogDatasheetsProvider(
        productType: _selectedProductType,
        material: _selectedMaterial,
        standard: _selectedStandard,
        valveType: _selectedValveType,
      ),
    );

    return CrmPageShell(
      title: 'Catalogo tecnico',
      subtitle: 'Valvulas y tuberias con fichas ASTM/ANSI/API',
      actions: <Widget>[
        ActionSquare(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.invalidate(
              technicalCatalogProductsProvider(
                productType: _selectedProductType,
                material: _selectedMaterial,
                standard: _selectedStandard,
                valveType: _selectedValveType,
              ),
            );
            ref.invalidate(
              technicalCatalogDatasheetsProvider(
                productType: _selectedProductType,
                material: _selectedMaterial,
                standard: _selectedStandard,
                valveType: _selectedValveType,
              ),
            );
          },
        ),
      ],
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(
            technicalCatalogProductsProvider(
              productType: _selectedProductType,
              material: _selectedMaterial,
              standard: _selectedStandard,
              valveType: _selectedValveType,
            ),
          );
          ref.invalidate(
            technicalCatalogDatasheetsProvider(
              productType: _selectedProductType,
              material: _selectedMaterial,
              standard: _selectedStandard,
              valveType: _selectedValveType,
            ),
          );
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            CardApp(
              child: _CatalogFilters(
                selectedProductType: _selectedProductType,
                selectedMaterial: _selectedMaterial,
                selectedStandard: _selectedStandard,
                selectedValveType: _selectedValveType,
                onProductTypeChanged: (value) {
                  setState(() => _selectedProductType = value);
                },
                onMaterialChanged: (value) {
                  setState(() => _selectedMaterial = value);
                },
                onStandardChanged: (value) {
                  setState(() => _selectedStandard = value);
                },
                onValveTypeChanged: (value) {
                  setState(() => _selectedValveType = value);
                },
              ),
            ),
            const SizedBox(height: 12),
            productsState.when(
              data: (items) => datasheetsState.when(
                data: (datasheets) =>
                    _ProductsList(products: items, datasheets: datasheets),
                loading: () => const _LoadingCard(height: 120),
                error: (_, _) =>
                    const _ErrorCard(message: 'No se pudieron cargar fichas.'),
              ),
              loading: () => const _LoadingCard(height: 160),
              error: (_, _) => const _ErrorCard(
                message: 'No se pudieron cargar productos del catalogo.',
              ),
            ),
            const SizedBox(height: 12),
            CardApp(child: _DatasheetsPanel(state: datasheetsState)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _CatalogFilters extends StatelessWidget {
  const _CatalogFilters({
    required this.selectedProductType,
    required this.selectedMaterial,
    required this.selectedStandard,
    required this.selectedValveType,
    required this.onProductTypeChanged,
    required this.onMaterialChanged,
    required this.onStandardChanged,
    required this.onValveTypeChanged,
  });

  final String? selectedProductType;
  final String? selectedMaterial;
  final String? selectedStandard;
  final String? selectedValveType;
  final ValueChanged<String?> onProductTypeChanged;
  final ValueChanged<String?> onMaterialChanged;
  final ValueChanged<String?> onStandardChanged;
  final ValueChanged<String?> onValveTypeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Filtros tecnicos', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            ChoiceChip(
              label: const Text('Todos'),
              selected: selectedProductType == null,
              onSelected: (_) => onProductTypeChanged(null),
            ),
            ..._catalogProductTypes.map(
              (type) => ChoiceChip(
                label: Text(type),
                selected: selectedProductType == type,
                onSelected: (_) => onProductTypeChanged(type),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _FilterSelect(
                label: 'Material',
                selectedValue: selectedMaterial,
                options: _materialOptions,
                onChanged: onMaterialChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FilterSelect(
                label: 'Norma',
                selectedValue: selectedStandard,
                options: _standardOptions,
                onChanged: onStandardChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _FilterSelect(
          label: 'Tipo de valvula',
          selectedValue: selectedValveType,
          options: _valveTypeOptions,
          onChanged: onValveTypeChanged,
        ),
      ],
    );
  }
}

class _FilterSelect extends StatelessWidget {
  const _FilterSelect({
    required this.label,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String?>(
      key: ValueKey<String>('${label}_${selectedValue ?? 'all'}'),
      isExpanded: true,
      initialValue: selectedValue,
      decoration: InputDecoration(labelText: label),
      items: <DropdownMenuItem<String?>>[
        const DropdownMenuItem<String?>(value: null, child: Text('Todos')),
        ...options.map(
          (value) => DropdownMenuItem<String?>(
            value: value,
            child: Text(value, overflow: TextOverflow.ellipsis),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

class _ProductsList extends StatelessWidget {
  const _ProductsList({required this.products, required this.datasheets});

  final List<CatalogProduct> products;
  final List<TechnicalDatasheet> datasheets;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _ErrorCard(
        message: 'No hay productos que cumplan con los filtros actuales.',
      );
    }

    final datasheetsById = <String, TechnicalDatasheet>{
      for (final sheet in datasheets) sheet.id: sheet,
    };

    return Column(
      children: products
          .map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CardApp(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            product.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            product.type.code,
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${product.sku} • ${product.manufacturer}'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _SpecChip('Material', product.material),
                        _SpecChip('Cedula', product.schedule),
                        _SpecChip('Diametro', product.nominalDiameter),
                        _SpecChip('Extremo', product.endType),
                        _SpecChip('Valvula', product.valveType),
                        _SpecChip('Clase', product.pressureClass),
                        _SpecChip('Norma', product.standard),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.datasheetIds
                          .map((id) => datasheetsById[id])
                          .whereType<TechnicalDatasheet>()
                          .map(
                            (sheet) => Chip(
                              avatar: const Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 17,
                              ),
                              label: Text(
                                sheet.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.panelBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DatasheetsPanel extends StatelessWidget {
  const _DatasheetsPanel({required this.state});

  final AsyncValue<List<TechnicalDatasheet>> state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Fichas tecnicas disponibles',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        state.when(
          data: (items) {
            if (items.isEmpty) {
              return const Text('No hay fichas para estos filtros.');
            }
            return Column(
              children: items
                  .map(
                    (sheet) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.yellow,
                        child: Icon(
                          Icons.description_outlined,
                          color: AppColors.black,
                        ),
                      ),
                      title: Text(sheet.title),
                      subtitle: Text(
                        '${sheet.manufacturer} • ${sheet.relatedSku} • ${sheet.fileType}',
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
          loading: () => const _LoadingCard(height: 100),
          error: (_, _) => const Text('No se pudieron cargar fichas tecnicas.'),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return CardApp(child: Text(message));
  }
}

const _catalogProductTypes = <String>[
  'Valvula',
  'Tuberia',
  'Conexion',
  'Accesorio',
];
const _materialOptions = <String>[
  'Acero al Carbon',
  'Inoxidable',
  'PVC',
  'CPVC',
];
const _standardOptions = <String>['ANSI', 'API', 'ASTM'];
const _valveTypeOptions = <String>[
  'Compuerta',
  'Bola',
  'Check',
  'Mariposa',
  'N/A',
];
