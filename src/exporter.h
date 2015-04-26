#ifndef EXPORTER_H
#define EXPORTER_H

#include <QFont>
#include <QObject>
#include <QPainter>

// -----------------------------------------------------------------------

class Exporter : public QObject
{
    Q_OBJECT

public:
    explicit Exporter(QObject *parent = 0);
    virtual ~Exporter();

    Q_INVOKABLE QString saveTextToImage(const QString &text);

private:
    static const QColor IMAGE_BACKGROUND_COLOR;
    static const QColor IMAGE_TEXT_COLOR;
    static const QString IMAGE_TEXT_FONT_FAMILY;
    static const int IMAGE_TEXT_FONT_SIZE;

    QFont m_font;
    QPainter m_painter;

};

// -----------------------------------------------------------------------

#endif // EXPORTER_H
