#include <QDateTime>
#include <QFontMetrics>
#include <QImage>
#include <QStandardPaths>

#include "exporter.h"

// -----------------------------------------------------------------------

const QColor Exporter::IMAGE_BACKGROUND_COLOR  = Qt::black;
const QColor Exporter::IMAGE_TEXT_COLOR        = Qt::white;
const QString Exporter::IMAGE_TEXT_FONT_FAMILY = "Monospace";
const int Exporter::IMAGE_TEXT_FONT_SIZE       = 14;

// -----------------------------------------------------------------------

Exporter::Exporter(QObject *parent) :
    QObject(parent)
{
    m_font.setFamily(IMAGE_TEXT_FONT_FAMILY);
    m_font.setPointSize(IMAGE_TEXT_FONT_SIZE);
    m_font.setWeight(QFont::Black);
    m_font.setStyleStrategy(QFont::PreferAntialias);
}

// -----------------------------------------------------------------------

Exporter::~Exporter()
{
}

// -----------------------------------------------------------------------

void Exporter::saveTextToImage(const QString &text)
{
    QString filename = QString("%1/cowsay-%2.png")
                .arg(QStandardPaths::writableLocation(QStandardPaths::PicturesLocation))
                .arg(QDateTime::currentDateTime().toString("yyyy-mm-dd-hh-mm-ss"));

    QFontMetrics font_metrics(m_font);
    QSize text_size = font_metrics.size(0, text);
    QImage image(text_size, QImage::Format_RGB888);
    image.fill(IMAGE_BACKGROUND_COLOR);

    m_painter.begin(&image);
    m_painter.setFont(m_font);
    m_painter.setRenderHint(QPainter::TextAntialiasing, true);
    m_painter.setPen(QPen(IMAGE_TEXT_COLOR));
    m_painter.drawText(image.rect(), text);
    m_painter.end();

    image.save(filename);
}
