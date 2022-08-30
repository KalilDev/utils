/// An API for Event Sourced Models. The model classes are stateful, but the
/// events and snapshots are stateless, with the snapshots being created,
/// converted to and from, and modified by the events via builder classes.
///
/// This allows moving the event cursor many times before having to build an
/// snapshot, possibly allowing better performance and lower memory usage.
library kalil_utils.event_sourcing;

export 'src/event_sourcing/event_sourcing.dart';
