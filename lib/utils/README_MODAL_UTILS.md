# ModalUtils - Система переиспользуемых модальных окон

## Обзор

`ModalUtils` - это утилитарный класс для создания переиспользуемых модальных окон с единым дизайном и функциональностью. Система предоставляет пять основных методов:

1. `showCustomModal` - универсальное модальное окно для любого контента
2. `showSkillEditModal` - специализированное модальное окно для редактирования навыков
3. `showAbilityEditModal` - специализированное модальное окно для редактирования характеристик
4. `showSaveEditModal` - специализированное модальное окно для редактирования испытаний
5. `showSpeedEditModal` - специализированное модальное окно для редактирования скоростей

## Основные возможности

- ✅ Единый дизайн для всех модальных окон
- ✅ Автоматическая обработка состояния загрузки
- ✅ Использование компонента `Btn` для кнопок
- ✅ Поддержка прокрутки для длинного контента
- ✅ Настраиваемая максимальная высота
- ✅ Кастомные заголовки и текст кнопок

## Примеры использования

### 1. Простое модальное окно

```dart
ModalUtils.showCustomModal(
  context: context,
  title: 'Редактировать профиль',
  content: Column(
    children: [
      TextField(
        decoration: InputDecoration(labelText: 'Имя'),
      ),
      SizedBox(height: 12),
      TextField(
        decoration: InputDecoration(labelText: 'Email'),
      ),
    ],
  ),
  onSave: () {
    // Логика сохранения
    print('Профиль сохранен');
  },
);
```

### 2. Модальное окно с кастомными кнопками

```dart
ModalUtils.showCustomModal(
  context: context,
  title: 'Подтверждение удаления',
  content: Text('Вы уверены, что хотите удалить этот элемент?'),
  saveButtonText: 'УДАЛИТЬ',
  cancelButtonText: 'ОТМЕНА',
  onSave: () => deleteItem(),
  onCancel: () => print('Отменено'),
);
```

### 3. Модальное окно с состоянием загрузки

```dart
bool isLoading = false;

ModalUtils.showCustomModal(
  context: context,
  title: 'Загрузка данных',
  content: Text('Пожалуйста, подождите...'),
  isLoading: isLoading,
  onSave: () async {
    isLoading = true;
    await loadData();
    isLoading = false;
  },
);
```

### 4. Модальное окно для редактирования навыка

```dart
// Контент с информацией о навыке
Widget skillInfoContent = Column(
  children: [
    Row(
      children: [
        Expanded(child: _buildInfoCard('Способность', 'ЛВК')),
        SizedBox(width: 12),
        Expanded(child: _buildInfoCard('Модификатор', '+2')),
      ],
    ),
    // ... остальная информация
  ],
);

// Поля для редактирования
Widget editingFields = Column(
  children: [
    TextField(decoration: InputDecoration(labelText: 'Очки навыка')),
    SizedBox(height: 12),
    TextField(decoration: InputDecoration(labelText: 'Бонус')),
  ],
);

ModalUtils.showSkillEditModal(
  context: context,
  skillName: 'Акробатика',
  skillInfoContent: skillInfoContent,
  editingFields: editingFields,
  onSave: () => saveSkill(),
);
```

### 5. Модальное окно для редактирования характеристик

```dart
// Контент для редактирования характеристик
Widget abilityContent = StatefulBuilder(
  builder: (context, setModalState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildEditableValueCard('Базовое значение', '14', onChanged)),
              SizedBox(width: 12),
              Expanded(child: _buildEditableValueCard('Временное значение', '-', onChanged, isOptional: true)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildValueDisplay('Модификатор', '+2')),
              SizedBox(width: 12),
              Expanded(child: _buildValueDisplay('Временный модификатор', '-')),
            ],
          ),
        ],
      ),
    );
  },
);

ModalUtils.showAbilityEditModal(
  context: context,
  abilityName: 'СИЛ',
  abilityContent: abilityContent,
  onSave: () => saveAbility(),
);
```

### 6. Модальное окно для редактирования испытаний

```dart
// Контент для редактирования испытаний
Widget saveContent = StatefulBuilder(
  builder: (context, setModalState) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildValueDisplay('Базовый бонус', '1')),
              SizedBox(width: 12),
              Expanded(child: _buildValueDisplay('Модификатор', '+2')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildEditableValueCard('Временный бонус', '+0', onChanged)),
              SizedBox(width: 12),
              Expanded(child: _buildEditableValueCard('Прочий бонус', '+0', onChanged)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildEditableValueCard('Магический бонус', '+0', onChanged)),
              SizedBox(width: 12),
              Expanded(child: _buildValueDisplay('ИТОГО', '+3')),
            ],
          ),
        ],
      ),
    );
  },
);

ModalUtils.showSaveEditModal(
  context: context,
  saveName: 'СТОЙ',
  saveContent: saveContent,
  onSave: () => saveSave(),
);
```

### 7. Модальное окно для редактирования скоростей

```dart
// Контент для редактирования скоростей
Widget speedContent = StatefulBuilder(
  builder: (context, setModalState) {
    return Column(
      children: [
        // Первый ряд: БЕЗ БРОНИ и В БРОНЕ
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('БЕЗ БРОНИ (фт)', '30', (v) {
                baseSpeed = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('В БРОНЕ (фт)', '20', (v) {
                armorSpeed = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Второй ряд: ПОЛЕТ и ПЛАВАНИЕ
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('ПОЛЕТ (фт)', '0', (v) {
                flySpeed = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('ПЛАВАНИЕ (фт)', '0', (v) {
                swimSpeed = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Третий ряд: ЛАЗАНИЕ и РЫТЬЕ
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('ЛАЗАНИЕ (фт)', '0', (v) {
                climbSpeed = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('РЫТЬЕ (фт)', '0', (v) {
                burrowSpeed = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
      ],
    );
  },
);

ModalUtils.showSpeedEditModal(
  context: context,
  speedContent: speedContent,
  onSave: () => saveSpeeds(),
);
```

### 8. Модальное окно для редактирования защиты

```dart
// Контент для редактирования защиты
Widget defenseContent = StatefulBuilder(
  builder: (context, setModalState) {
    return Column(
      children: [
        // Первый ряд: Броня и Щит
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('Броня', '5', (v) {
                armorBonus = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('Щит', '2', (v) {
                shieldBonus = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Второй ряд: Естественная и Отражение
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('Естественная', '1', (v) {
                naturalArmor = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('Отражение', '0', (v) {
                deflectionBonus = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
        SizedBox(height: 12),
        // Третий ряд: Прочий и Размер
        Row(
          children: [
            Expanded(
              child: _buildEditableValueCard('Прочий', '0', (v) {
                miscACBonus = v;
                setModalState(() {});
              }),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildEditableValueCard('Размер', '0', (v) {
                sizeModifier = v;
                setModalState(() {});
              }),
            ),
          ],
        ),
        SizedBox(height: 20),
        
        // Формула расчета КБ
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Формула расчета КБ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildValueDisplay(
                      'Базовая КБ + ЛВК',
                      '10 + ${_calculateModifier(hero.dexterity)}',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ИТОГО КБ:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${10 + _calculateModifier(hero.dexterity) + armorBonus + shieldBonus + naturalArmor + deflectionBonus + sizeModifier + miscACBonus}',
                      style: TextStyle(
                        color: Color(0xFF00FF00),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  },
);

// Показываем модальное окно
ModalUtils.showDefenseEditModal(
  context: context,
  defenseName: 'КБ',
  defenseContent: defenseContent,
  onSave: () => saveDefense(),
);
```

### 9. Модальное окно для редактирования инициативы

```dart
// Контент для редактирования инициативы
Widget initiativeContent = StatefulBuilder(
  builder: (context, setModalState) {
    final dexterityModifier = _calculateModifier(hero.dexterity);
    final totalModifier = dexterityModifier + miscInitiativeBonus;
    
    return Column(
      children: [
        // Формула расчета инициативы
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Формула расчета инициативы',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildValueDisplay(
                      'ЛВК + Прочий',
                      '$dexterityModifier + $miscInitiativeBonus',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Итоговая инициатива:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${totalModifier >= 0 ? '+' : ''}$totalModifier',
                      style: TextStyle(
                        color: Color(0xFF00FF00),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        
        // Поле для редактирования
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Значения (нажмите для редактирования)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              _buildEditableValueCard(
                'Прочий бонус',
                miscInitiativeBonus.toString(),
                (v) {
                  miscInitiativeBonus = v;
                  setModalState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  },
);

// Показываем модальное окно
ModalUtils.showInitiativeEditModal(
  context: context,
  initiativeContent: initiativeContent,
  onSave: () => saveInitiative(),
);
```

### 10. Модальное окно для редактирования атаки (БМА)

```dart
// Контент для редактирования БМА
Widget attackContent = StatefulBuilder(
  builder: (context, setModalState) {
    return _buildEditableValueCard(
      'БМА',
      baseAttackBonus.toString(),
      (v) {
        baseAttackBonus = v;
        setModalState(() {});
      },
    );
  },
);

// Показываем модальное окно
ModalUtils.showAttackEditModal(
  context: context,
  attackContent: attackContent,
  onSave: () => saveAttack(),
);

### 5. Модальное окно с настраиваемой высотой

```dart
ModalUtils.showCustomModal(
  context: context,
  title: 'Длинный список',
  content: ListView.builder(
    itemCount: 100,
    itemBuilder: (context, index) => ListTile(
      title: Text('Элемент $index'),
    ),
  ),
  maxHeightRatio: 0.9, // 90% от высоты экрана
  onSave: () => saveList(),
);
```

## Параметры

### showCustomModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `title` | `String` | ✅ | Заголовок модального окна |
| `content` | `Widget` | ✅ | Основной контент |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `onCancel` | `VoidCallback?` | ❌ | Функция отмены (по умолчанию закрывает окно) |
| `saveButtonText` | `String` | ❌ | Текст кнопки сохранения (по умолчанию "СОХРАНИТЬ") |
| `cancelButtonText` | `String` | ❌ | Текст кнопки отмены (по умолчанию "ОТМЕНА") |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.8) |

### showSkillEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `skillName` | `String` | ✅ | Название навыка |
| `skillInfoContent` | `Widget` | ✅ | Виджет с информацией о навыке |
| `editingFields` | `Widget` | ✅ | Виджет с полями для редактирования |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |

### showAbilityEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `abilityName` | `String` | ✅ | Название характеристики |
| `abilityContent` | `Widget` | ✅ | Виджет с контентом для редактирования |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.5) |

### showSaveEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `saveName` | `String` | ✅ | Название испытания |
| `saveContent` | `Widget` | ✅ | Виджет с контентом для редактирования |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.8) |

### showSpeedEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `speedContent` | `Widget` | ✅ | Виджет с контентом для редактирования |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.8) |

### showDefenseEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `defenseName` | `String` | ✅ | Название типа защиты (например, "КБ", "КБ касания", "КБ без инициативы") |
| `defenseContent` | `Widget` | ✅ | Виджет с контентом для редактирования защиты |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.8) |

### showInitiativeEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `initiativeContent` | `Widget` | ✅ | Виджет с контентом для редактирования инициативы |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.6) |

### showAttackEditModal

| Параметр | Тип | Обязательный | Описание |
|----------|-----|--------------|----------|
| `context` | `BuildContext` | ✅ | Контекст приложения |
| `attackContent` | `Widget` | ✅ | Виджет с контентом для редактирования атаки |
| `onSave` | `VoidCallback` | ✅ | Функция сохранения |
| `isLoading` | `bool` | ❌ | Состояние загрузки (по умолчанию false) |
| `maxHeightRatio` | `double` | ❌ | Максимальная высота в процентах от экрана (по умолчанию 0.5) |

## Миграция существующих модальных окон

### До (старый способ):

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => Container(
    decoration: BoxDecoration(
      color: Color(0xFF1A1A1A),
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Column(
      children: [
        Text('Заголовок'),
        // ... контент
        Row(
          children: [
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('ОТМЕНА')),
            ElevatedButton(onPressed: save, child: Text('СОХРАНИТЬ')),
          ],
        ),
      ],
    ),
  ),
);
```

### После (новый способ):

```dart
ModalUtils.showCustomModal(
  context: context,
  title: 'Заголовок',
  content: YourContentWidget(),
  onSave: save,
);
```

## Преимущества

1. **Единообразие**: Все модальные окна имеют одинаковый дизайн
2. **Переиспользование**: Один код для множества модальных окон
3. **Удобство**: Меньше кода для создания модальных окон
4. **Поддержка**: Легко изменять дизайн всех модальных окон сразу
5. **Типобезопасность**: Строгая типизация параметров
6. **Документация**: Подробные примеры использования 