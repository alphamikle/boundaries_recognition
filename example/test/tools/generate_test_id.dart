String generateId(Set<String> imageColors, Set<String> backgroundColors) => [
      'Check with config: ',
      [imageColors.join(' or '), backgroundColors.join(' or ')].join(' and '),
    ].join();
