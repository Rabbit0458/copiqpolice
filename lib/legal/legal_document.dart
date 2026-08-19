// lib/legal/legal_document.dart
//
// Modèle d'un document juridique publié dans public.information_contents.
// Correspond exactement aux colonnes lues par LegalRepository — voir
// lib/legal/legal_repository.dart.

class LegalDocument {
  final String id;
  final String documentKey; // = content_type en base
  final String slug;
  final String title;
  final String summary;
  final String bodyMd;
  final String status;
  final String? version;
  final DateTime? publishedAt;
  final DateTime updatedAt;

  const LegalDocument({
    required this.id,
    required this.documentKey,
    required this.slug,
    required this.title,
    required this.summary,
    required this.bodyMd,
    required this.status,
    required this.version,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory LegalDocument.fromJson(Map<String, dynamic> json) {
    return LegalDocument(
      id: json['id'] as String,
      documentKey: json['content_type'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      bodyMd: json['body_md'] as String? ?? '',
      status: json['status'] as String? ?? 'draft',
      version: (json['version'] as String?)?.trim().isEmpty ?? true
          ? null
          : json['version'] as String,
      publishedAt: DateTime.tryParse('${json['published_at']}'),
      updatedAt: DateTime.tryParse('${json['updated_at']}') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toCacheJson() => {
    'id': id,
    'content_type': documentKey,
    'slug': slug,
    'title': title,
    'summary': summary,
    'body_md': bodyMd,
    'status': status,
    'version': version,
    'published_at': publishedAt?.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
